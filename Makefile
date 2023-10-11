# Build win32 installer for get_iplayer
# Prereqs: MSYS2 (64-bit), INNO Setup 5
# Prereqs: pacman -S git make p7zip winpty
# Build 32-bit release (VERSION = tag in get_iplayer repo w/o "v" prefix"):
# VERSION=3.14 make release
# Build 64-bit release
# VERSION=3.14 WIN64=1 make release
# Rebuild all dependencies and build release:
# VERSION=3.14 make distclean release
# Specify installer patch number for release (default = 0):
# VERSION=3.14 PATCH=1 make release
# Flag as work in progress for development
# VERSION=3.14 PATCH=1 WIP=1 make release
# Use alternate tag/branch in get_iplayer repo
# VERSION=3.14 PATCH=1 WIP=1 TAG=develop make release

ifndef VERSION
	gip_tag := master
	VERSION := 0.0
	PATCH := 0
	WIP := 1
else
	gip_tag := v$(VERSION)
ifndef PATCH
	PATCH := 0
endif
endif
ifdef TAG
	gip_tag := $(TAG)
endif
ifdef WIN64
	bits := 64
	arch := x64
	DWIN64 := -DWIN64
else
	bits := 32
	arch := x86
endif
setup_ver := $(VERSION).$(PATCH)
ifndef WIP
	setup_tag := $(shell git tag -l $(setup_ver))
ifeq ($(setup_tag), $(setup_ver))
	WIP := 1
endif
endif
build := build-$(arch)
src := $(build)/src
# inno setup
setup_name := get_iplayer
setup_iss := $(setup_name).iss
curr_ver := $(shell awk '/#define AppVersion/ {gsub("\"", "", $$3); print $$3;}' "$(setup_iss)")
setup_suffix := -setup
ifdef NOPERL
	DNOPERL := -DNOPERL
	setup_suffix := $(setup_suffix)-noperl
endif
ifdef NOUTILS
	DNOUTILS := -DNOUTILS
	setup_suffix := $(setup_suffix)-noutils
endif
setup_base := $(setup_name)-$(setup_ver)-windows-$(arch)$(setup_suffix)
setup_file := $(setup_base).exe
setup_path := $(build)/$(setup_file)
setup_chk_file := $(setup_file).sha256
setup_chk_path := $(dir $(setup_path))/$(setup_chk_file)
prog_files := $(PROGRAMFILES)
prog_files_32 := $(PROGRAMFILES) (x86)
ifdef WIN64
	inst_dir := $(prog_files)/$(setup_name)
else
	inst_dir := $(prog_files_32)/$(setup_name)
endif
iscc_inst := $(prog_files_32)/Inno Setup 5
iscc := $(iscc_inst)/ISCC.exe
# strawberry perl
sbpl_ver := 5.32.1.1
sbpl_base := strawberry-perl-$(sbpl_ver)-$(bits)bit-portable
sbpl_dir := $(build)/$(sbpl_base)
sbpl_zip_file := $(sbpl_base).zip
sbpl_zip_path := $(build)/$(sbpl_zip_file)
sbpl_zip_url := http://strawberryperl.com/download/$(sbpl_ver)/$(sbpl_zip_file)
sbpl_exe := $(sbpl_dir)/portableshell.bat
sbpl_cpanm := $(sbpl_dir)/perl/bin/cpanm.bat
perldist_strawberry := $(sbpl_dir)/perl/site/bin/perldist_strawberry.bat
# perl
perl_ver := 5.32.1
perl_base := perl-core-$(perl_ver)-$(bits)bit-portable
perl_dir := $(build)/$(perl_base)
image_dir := $(build)/$(perl_base)-image
work_dir := $(build)/$(perl_base)-work
perl_pp := perl-$(bits)bit.pp
perldist_strawberry_ver := $(perl_ver).1
perldist_strawberry_zip := $(work_dir)/output/perl-$(perldist_strawberry_ver)-$(bits)bit-portable.zip
perl_exe := $(perl_dir)/portableshell.bat
perl_zip_file := $(perl_base).zip
perl_zip_path := $(build)/$(perl_zip_file)
cpanm_exe := $(build)/cpanm
cpanm_exe_url := https://cpanmin.us
gipl_base := perl-gip-$(perl_ver)-$(bits)bit-portable
gipl_dir := $(build)/$(gipl_base)
gipl_zip_file := $(gipl_base).zip
gipl_zip_path := $(build)/$(gipl_zip_file)
gipl_exe := $(gipl_dir)/portableshell.bat
perl_src_dir := $(src)/perl
# get_iplayer
gip_repo := ../get_iplayer
gip_zip_file := get_iplayer-$(gip_tag).zip
gip_zip_path := $(build)/$(gip_zip_file)
gip_src_dir := $(src)/get_iplayer
# atomicparsley
ifdef WIN64
	atomicparsley_arch := x86_64
else
	atomicparsley_arch := i386
endif
atomicparsley_ver := 0.9.7-get_iplayer.4
atomicparsley_zip_file := AtomicParsley-$(atomicparsley_ver)-windows-$(atomicparsley_arch)-static.zip
atomicparsley_zip_url := https://github.com/get-iplayer/atomicparsley/releases/download/$(atomicparsley_ver)/$(atomicparsley_zip_file)
atomicparsley_zip_path := $(build)/$(atomicparsley_zip_file)
atomicparsley_src_dir := $(src)/atomicparsley
# ffmpeg
ifdef WIN64
	ffmpeg_arch := x64
else
	ffmpeg_arch := ia32
endif
ffmpeg_ver := 6.0
ffmpeg_base := ffmpeg-$(ffmpeg_ver)-win32-$(ffmpeg_arch)
ffmpeg_zip_file := $(ffmpeg_base).gz
ffmpeg_zip_path := $(build)/$(ffmpeg_zip_file)
ffmpeg_zip_url := https://github.com/eugeneware/ffmpeg-static/releases/download/b$(ffmpeg_ver)/ffmpeg-win32-$(ffmpeg_arch).gz
ffmpeg_lic_file := $(ffmpeg_base).LICENSE
ffmpeg_lic_path := $(build)/$(ffmpeg_lic_file)
ffmpeg_lic_url := https://github.com/eugeneware/ffmpeg-static/releases/download/b$(ffmpeg_ver)/win32-x64.LICENSE
ffmpeg_src_dir := $(src)/ffmpeg

dummy:
	@echo Nothing to make

$(sbpl_zip_path):
ifndef NOPERL
	@mkdir -p $(dir $(sbpl_zip_path))
	@echo downloading $(sbpl_zip_url)
	@curl -\#fkL -o $(sbpl_zip_path) $(sbpl_zip_url)
	@echo downloaded $(sbpl_zip_path)
	@touch $(sbpl_zip_path)
endif

$(sbpl_dir): $(sbpl_zip_path)
ifndef NOPERL
	@mkdir -p $(sbpl_dir)
	@7za x -aoa -o$(sbpl_dir) $(sbpl_zip_path)
	@winpty $(sbpl_exe) $(sbpl_cpanm) -n Perl::Dist::Strawberry
	@echo created $(sbpl_dir)
	@touch $(sbpl_dir)
endif

sbpl: $(sbpl_dir)

$(perl_zip_path): $(sbpl_dir)
ifndef NOPERL
	@mkdir -p $(image_dir)
	@mkdir -p $(work_dir)
	@winpty $(sbpl_exe) $(perldist_strawberry) -job "$$(echo $$PWD)/$(perl_pp)" \
		-image_dir "$$(echo $$PWD)/$(image_dir)" -working_dir "$$(echo $$PWD)/$(work_dir)" \
		-perl_64bitint -notest_core -notest_modules -nointeractive -norestorepoints
	@cp -f $(perldist_strawberry_zip) $(perl_zip_path)
	@echo created $(perl_zip_path)
	@touch $(perl_zip_path)
endif

perlcore: $(perl_zip_path)

$(cpanm_exe):
ifndef NOPERL
	@mkdir -p $(dir $(cpanm_exe))
	@echo downloading $(cpanm_exe_url)
	@curl -\#fkL -o $(cpanm_exe) https://cpanmin.us
	@echo downloaded $(cpanm_exe)
	@touch $(cpanm_exe)
endif

$(gipl_dir): $(perl_zip_path) $(cpanm_exe)
ifndef NOPERL
	@mkdir -p $(gipl_dir)
	@7za x -aoa -o$(gipl_dir) $(perl_zip_path)
	@$(gipl_exe) $(cpanm_exe) --notest --installdeps .
	@echo created $(gipl_dir)
	@touch $(gipl_dir)
endif

$(gipl_zip_path): $(gipl_dir)
ifndef NOPERL
	@pushd $(gipl_dir) > /dev/null; \
		7za a ../$(gipl_zip_file) * ; \
	popd > /dev/null;
	@echo created $(gipl_zip_path)
	@touch $(gipl_zip_path)
endif

gipl: $(gipl_zip_path)

$(perl_src_dir): $(gipl_zip_path)
ifndef NOPERL
	@mkdir -p $(perl_src_dir)
	@7za x -aoa -o$(dir $(perl_src_dir)) $(gipl_zip_path) perl/bin/perl.exe perl/bin/*.dll perl/{lib,site,vendor}
	@7za e -aoa -o$(perl_src_dir)/bin $(gipl_zip_path) c/bin/{libcrypto,libgdbm,libiconv,liblzma,libssl,libxml2,zlib}*.dll
	@7za x -aoa -o$(perl_src_dir) $(gipl_zip_path) licenses
	@echo created $(perl_src_dir)
	@touch $(perl_src_dir)
endif

perl: $(perl_src_dir)

perlclean:
	@rm -fr $(perl_src_dir)
	@echo removed $(perl_src_dir)

$(gip_zip_path):
ifndef NOGIP
	@mkdir -p $(dir $(gip_zip_path))
	@git --git-dir=$(gip_repo)/.git --work-tree=$(gip_repo) update-index --refresh --unmerged
	@git --git-dir=$(gip_repo)/.git archive --format=zip $(gip_tag) > $(gip_zip_path)
	@echo created $(gip_zip_path)
	@touch $(gip_zip_path)
endif

$(gip_src_dir): $(gip_zip_path)
ifndef NOGIP
	@mkdir -p $(gip_src_dir)
	@7za e -aoa -o$(gip_src_dir) $(gip_zip_path) get_iplayer get_iplayer.cgi LICENSE.txt
	@sed -b -E -i.bak -e 's/^(my (\$$version_text|\$$VERSION_TEXT)).*/\1 = "$(setup_ver)-\$$^O-$(arch)";/' \
		$(gip_src_dir)/{get_iplayer,get_iplayer.cgi}
	@rm -f $(gip_src_dir)/{get_iplayer,get_iplayer.cgi}.bak
	@echo created $(gip_src_dir)
	@touch $(gip_src_dir)
endif

gip: $(gip_src_dir)

gipclean:
	@rm -fr $(gip_src_dir)
	@echo removed $(gip_src_dir)

$(atomicparsley_zip_path):
ifndef NOUTILS
	@mkdir -p $(dir $(atomicparsley_zip_path))
	@echo downloading $(atomicparsley_zip_url)
	@curl -\#fkL -o $(atomicparsley_zip_path) $(atomicparsley_zip_url)
	@echo downloaded $(atomicparsley_zip_path)
	@touch $(atomicparsley_zip_path)
endif

$(atomicparsley_src_dir): $(atomicparsley_zip_path)
ifndef NOUTILS
	@mkdir -p $(atomicparsley_src_dir)
	@7za e -aoa -o$(atomicparsley_src_dir) $(atomicparsley_zip_path) AtomicParsley.exe COPYING
	@echo created $(atomicparsley_src_dir)
	@touch $(atomicparsley_src_dir)
endif

atomicparsley: $(atomicparsley_src_dir)

atomicparsleyclean:
	@rm -fr $(atomicparsley_src_dir)
	@echo removed $(atomicparsley_src_dir)

$(ffmpeg_zip_path):
ifndef NOUTILS
	@mkdir -p $(dir $(ffmpeg_zip_path))
	@echo downloading $(ffmpeg_zip_url)
	@curl -\#fkL -o $(ffmpeg_zip_path) $(ffmpeg_zip_url)
	@echo downloaded $(ffmpeg_zip_path)
	@touch $(ffmpeg_zip_path)
endif

$(ffmpeg_lic_path):
ifndef NOUTILS
	@mkdir -p $(dir $(ffmpeg_lic_path))
	@echo downloading $(ffmpeg_lic_url)
	@curl -\#fkL -o $(ffmpeg_lic_path) $(ffmpeg_lic_url)
	@echo downloaded $(ffmpeg_lic_path)
	@touch $(ffmpeg_lic_path)
endif

$(ffmpeg_src_dir): $(ffmpeg_zip_path) $(ffmpeg_lic_path)
ifndef NOUTILS
	@mkdir -p $(ffmpeg_src_dir)
	@gunzip -c $(ffmpeg_zip_path) > $(ffmpeg_src_dir)/ffmpeg.exe
	@cp -f $(ffmpeg_lic_path) $(ffmpeg_src_dir)/LICENSE.txt
	@echo created $(ffmpeg_src_dir)
	@touch $(ffmpeg_src_dir)
endif

ffmpeg: $(ffmpeg_src_dir)

ffmpegclean:
	@rm -fr $(ffmpeg_src_dir)
	@echo removed $(ffmpeg_src_dir)

deps: perl gip atomicparsley ffmpeg

depsclean: perlclean gipclean atomicparsleyclean ffmpegclean

$(setup_path): $(setup_iss) $(perl_src_dir) $(gip_src_dir) $(atomicparsley_src_dir) $(ffmpeg_src_dir)
ifndef NOSETUP
	@mkdir -p $(dir $(setup_path))
	@echo building $(setup_path)
	@"$(iscc)" $(DWIN64) $(DNOPERL) $(DNOUTILS) -DAppVersion=$(setup_ver) -O$(build) -F$(setup_base) -Q $(setup_iss)
	@echo built $(setup_path)
	@touch $(setup_path)
endif

$(setup_chk_path): $(setup_path)
ifndef NOSETUP
	@mkdir -p $(dir $(setup_path))
	@pushd $(dir $(setup_path)) > /dev/null; \
		sha256sum $(setup_file) > $(setup_chk_file) || exit 2; \
	popd > /dev/null;
	@echo created $(setup_chk_path)
	@touch $(setup_chk_path)
endif

setup: $(setup_path) $(setup_chk_path)

setupclean:
	@rm -f $(setup_path)
	@echo removed $(setup_path)
	@rm -f $(setup_chk_path)
	@echo removed $(setup_chk_path)

checkout:
ifndef WIP
	@git update-index --refresh --unmerged
	@git checkout master
endif

commit:
	@sed -b -E -i.bak -e 's/(#define AppVersion) "[0-9]+\.[0-9]+\.[0-9]+"/\1 "$(setup_ver)"/' "$(setup_iss)"
	@rm -f $(setup_iss).bak
ifndef WIP
	@git commit -m $(setup_ver) $(setup_iss)
	@git tag $(setup_ver)
	@echo tagged $(setup_ver)
else
	@sed -b -E -i.bak -e 's/(#define AppVersion) "[0-9]+\.[0-9]+\.[0-9]+"/\1 "$(curr_ver)"/' "$(setup_iss)"
	@rm -f $(setup_iss).bak
endif

clean: setupclean depsclean

distclean: clean
	@rm -fr $(build)
	@echo removed $(build)

release: checkout setup commit
	@echo built release $(setup_ver)

install:
	@$(setup_path) //VERYSILENT //SUPPRESSMSGBOXES //TASKS="desktopicons"
	@echo installed

installgui:
	@$(setup_path) //TASKS="desktopicons"
	@echo installed

uninstall:
	@"$(inst_dir)"/unins000.exe //VERYSILENT //SUPPRESSMSGBOXES
	@echo uninstalled

uninstallgui:
	@"$(inst_dir)"/unins000.exe
	@echo uninstalled
