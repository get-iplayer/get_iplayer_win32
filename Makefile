# Build win32 installer for get_iplayer
# Prereqs: MSYS2 (64-bit), INNO Setup 5
# Prereqs: pacman -S git make p7zip winpty
# Build release (VERSION = tag in get_iplayer repo w/o "v" prefix"):
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
setup_exe := $(setup_base).exe
build_setup_exe := $(build)/$(setup_exe)
prog_files := $(PROGRAMFILES)
prog_files_32 := $(PROGRAMFILES) (x86)
ifdef WIN64
	gip_inst := $(prog_files)/$(setup_name)
else
	gip_inst := $(prog_files_32)/$(setup_name)
endif
sbpl_ver := 5.30.2.1
sbpl_base := strawberry-perl-$(sbpl_ver)-$(bits)bit-portable
sbpl_zip := $(sbpl_base).zip
build_sbpl := $(build)/$(sbpl_base)
sbpl_zip_url := http://strawberryperl.com/download/$(sbpl_ver)/$(sbpl_zip)
build_sbpl_zip := $(build)/$(sbpl_zip)
sbpl_exe := $(build_sbpl)/portableshell.bat
sbpl_cpanm := $(build_sbpl)/perl/bin/cpanm.bat
perldist_strawberry := $(build_sbpl)/perl/site/bin/perldist_strawberry.bat
perl_ver := 5.32.0.1
perl_base := perl
build_perl := $(build)/$(perl_base)
build_work := $(build)/work
perl_pp := $(perl_base)-$(bits)bit.pp
perldist_strawberry_ver :=$(perl_ver)
perldist_strawberry_zip := $(build_work)/output/$(perl_base)-$(perldist_strawberry_ver)-$(bits)bit-portable.zip
perl_exe := $(build_perl)/portableshell.bat
perl_cpanm := $(build_perl)/perl/bin/cpanm.bat
perl_zip := $(perl_base)-$(perl_ver)-$(bits)bit.zip
build_perl_zip := $(build)/$(perl_zip)
src_perl := $(src)/perl
src_perl_exe := $(src_perl)/bin/perl.exe
gip_repo := ../get_iplayer
gip_zip := get_iplayer-$(gip_tag).zip
build_gip_zip := $(build)/$(gip_zip)
src_gip := $(src)/get_iplayer
atomicparsley_ver := 0.9.7-get_iplayer.1
atomicparsley_zip := AtomicParsley-$(atomicparsley_ver)-windows-$(arch).zip
atomicparsley_zip_url := https://github.com/get-iplayer/atomicparsley/releases/download/$(atomicparsley_ver)/$(atomicparsley_zip)
build_atomicparsley_zip := $(build)/$(atomicparsley_zip)
src_atomicparsley := $(src)/atomicparsley
ffmpeg_ver := 4.2.3
ffmpeg_zip := ffmpeg-$(ffmpeg_ver)-win$(bits)-static.zip
ffmpeg_zip_url := https://github.com/advancedfx/ffmpeg.zeranoe.com-builds-mirror/releases/download/20200915/$(ffmpeg_zip)
build_ffmpeg_zip := $(build)/$(ffmpeg_zip)
src_ffmpeg := $(src)/ffmpeg
iscc_inst := $(prog_files_32)/Inno Setup 5
iscc := $(iscc_inst)/ISCC.exe

dummy:
	@echo Nothing to make

$(build_sbpl_zip):
ifndef NOPERL
	@mkdir -p $(build)
	@echo downloading $(sbpl_zip_url)
	@curl -\#fkL -o $(build_sbpl_zip) $(sbpl_zip_url)
	@echo downloaded $(build_sbpl_zip)
	@touch $(build_sbpl_zip)
endif

$(build_sbpl): $(build_sbpl_zip)
ifndef NOPERL
	@mkdir -p $(build_sbpl)
	@7za x -aoa -o$(build_sbpl) $(build_sbpl_zip)
	@winpty $(sbpl_exe) $(sbpl_cpanm) -n Perl::Dist::Strawberry
	@echo created $(build_sbpl)
	@touch $(build_sbpl)
endif

sbpl: $(build_sbpl)

$(build_perl_zip): $(build_sbpl)
ifndef NOPERL
	@mkdir -p $(build_perl)
	@mkdir -p $(build_work)
	@winpty $(sbpl_exe) $(perldist_strawberry) -job "$$(echo $$PWD)/$(perl_pp)" \
		-image_dir "$$(echo $$PWD)/$(build_perl)" -working_dir "$$(echo $$PWD)/$(build_work)" \
		-perl_64bitint -notest_core -notest_modules -nointeractive -norestorepoints
	@cp -f $(perldist_strawberry_zip) $(build_perl_zip)
	@echo created $(build_perl_zip)
	@touch $(build_perl_zip)
endif

$(src_perl): $(build_perl_zip)
ifndef NOPERL
	@mkdir -p $(src_perl)
	@7za x -aoa -o$(src) $(build_perl_zip) perl/bin/perl.exe perl/bin/*.dll perl/{lib,vendor}
	@7za x -aoa -o$(src_perl) $(build_perl_zip) licenses
	@7za e -aoa -o$(src_perl)/bin $(build_perl_zip) c/bin/{libcrypto,libgdbm,libiconv,liblzma,libssl,libxml2,zlib}*.dll
	@echo created $(src_perl)
	@touch $(src_perl)
endif

perl: $(src_perl)

perlclean:
	@rm -fr $(src_perl)
	@echo removed $(src_perl)

$(build_gip_zip):
ifndef NOGIP
	@mkdir -p $(build)
	@git --git-dir=$(gip_repo)/.git --work-tree=$(gip_repo) update-index --refresh --unmerged
	@git --git-dir=$(gip_repo)/.git archive --format=zip $(gip_tag) > $(build_gip_zip)
	@echo created $(build_gip_zip)
	@touch $(build_gip_zip)
endif

$(src_gip): $(build_gip_zip)
ifndef NOGIP
	@mkdir -p $(src_gip)
	@7za e -aoa -o$(src_gip) $(build_gip_zip) get_iplayer get_iplayer.cgi LICENSE.txt
	@sed -b -E -i.bak -e 's/^(my (\$$version_text|\$$VERSION_TEXT)).*/\1 = "$(setup_ver)-\$$^O-$(arch)";/' \
		$(src_gip)/{get_iplayer,get_iplayer.cgi}
	@rm -f $(src_gip)/{get_iplayer,get_iplayer.cgi}.bak
	@echo created $(src_gip)
	@touch $(src_gip)
endif

gip: $(src_gip)

gipclean:
	@rm -fr $(src_gip)
	@echo removed $(src_gip)

$(build_atomicparsley_zip):
ifndef NOUTILS
	@mkdir -p $(build)
	@echo downloading $(atomicparsley_zip_url)
	@curl -\#fkL -o $(build_atomicparsley_zip) $(atomicparsley_zip_url)
	@echo downloaded $(build_atomicparsley_zip)
	@touch $(build_atomicparsley_zip)
endif

$(src_atomicparsley): $(build_atomicparsley_zip)
ifndef NOUTILS
	@mkdir -p $(src_atomicparsley)
	@7za e -aoa -o$(src_atomicparsley) $(build_atomicparsley_zip) AtomicParsley.exe COPYING
	@echo created $(src_atomicparsley)
	@touch $(src_atomicparsley)
endif

atomicparsley: $(src_atomicparsley)

atomicparsleyclean:
	@rm -fr $(src_atomicparsley)
	@echo removed $(src_atomicparsley)

$(build_ffmpeg_zip):
ifndef NOUTILS
	@mkdir -p $(build)
	@echo downloading $(ffmpeg_zip_url)
	@curl -\#fkL -o $(build_ffmpeg_zip) $(ffmpeg_zip_url)
	@echo downloaded $(build_ffmpeg_zip)
	@touch $(build_ffmpeg_zip)
endif

$(src_ffmpeg): $(build_ffmpeg_zip)
ifndef NOUTILS
	@mkdir -p $(src_ffmpeg)
	@7za e -aoa -o$(src_ffmpeg) $(build_ffmpeg_zip) */bin/ffmpeg.exe */LICENSE.txt */README.txt
	@echo created $(src_ffmpeg)
	@touch $(src_ffmpeg)
endif

ffmpeg: $(src_ffmpeg)

ffmpegclean:
	@rm -fr $(src_ffmpeg)
	@echo removed $(src_ffmpeg)

utils: atomicparsley ffmpeg

utilsclean: atomicparsleyclean ffmpegclean

$(build_licenses):
ifndef NOLICENSES
	@mkdir -p $(build_licenses)
	@curl -\#fkL -o $(build_licenses)/gpl.txt https://www.gnu.org/licenses/gpl.txt
	@curl -\#fkL -o $(build_licenses)/lgpl.txt https://www.gnu.org/licenses/lgpl.txt
	@curl -\#fkL -o $(build_licenses)/gpl-2.0.txt https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
	@curl -\#fkL -o $(build_licenses)/lgpl-2.1.txt https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
	@echo created $(build_licenses)
	@touch $(build_licenses)
endif

licenses: $(build_licenses)

licensesclean:
	@rm -fr $(build_licenses)
	@echo removed $(build_licenses)
	
deps: perl gip atomicparsley ffmpeg

depsclean: perlclean gipclean atomicparsleyclean ffmpegclean

$(build_setup_exe): $(setup_iss)
ifndef NOSETUP
	@mkdir -p $(build)
	@echo building $(build_setup_exe)
	@"$(iscc)" $(DWIN64) $(DNOPERL) $(DNOUTILS) -DAppVersion=$(setup_ver) -O$(build) -F$(setup_base) -Q $(setup_iss)
	@pushd $(build) > /dev/null; \
		sha256sum $(setup_exe) > $(setup_exe).sha256 || exit 2; \
	popd > /dev/null;
	@echo built $(build_setup_exe)
	@touch $(build_setup_exe)
endif

setup: $(build_setup_exe)

setupclean:
	@rm -fr $(build_setup_exe)
	@echo removed $(build_setup_exe)

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

clean:
	@rm -fr $(build_setup_exe)
	@echo removed $(build_setup_exe)
	@rm -fr $(src)
	@echo removed $(src)

distclean:
	@rm -fr $(build)
	@echo removed $(build)

release: clean checkout deps setup commit
	@echo built release $(setup_ver)

install:
	@$(build_setup_exe) //VERYSILENT //SUPPRESSMSGBOXES //TASKS="desktopicons"
	@echo installed

installgui:
	@$(build_setup_exe) //TASKS="desktopicons"
	@echo installed

uninstall:
	@"$(gip_inst)"/unins000.exe //VERYSILENT //SUPPRESSMSGBOXES
	@echo uninstalled

uninstallgui:
	@"$(gip_inst)"/unins000.exe
	@echo uninstalled
