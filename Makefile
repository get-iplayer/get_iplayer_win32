# Build win32 installer for get_iplayer
# Requires: Git for Windows 32-bit w/Git Bash, Strawberry Perl 32-bit w/gmake, Inno Setup
# Build release (VERSION = tag in get_iplayer repo w/o "v" prefix"):
# VERSION=3.14 gmake release
# Rebuild all dependencies and build release:
# VERSION=3.14 gmake distclean release
# Specify installer patch number for release (default = 0):
# VERSION=3.14 PATCH=1 gmake release
# Flag as work in progress for development
# VERSION=3.14 PATCH=1 WIP=1 gmake release
# Use alternate tag/branch in get_iplayer repo
# VERSION=3.14 PATCH=1 WIP=1 TAG=develop gmake release

ifndef VERSION
	gip_tag := master
	VERSION := 0.00
	WIP := 1
else
	gip_tag := v$(VERSION)
endif
ifndef PATCH
	PATCH := 0
endif
ifdef TAG
	gip_tag := $(TAG)
endif

build := build
src := $(build)/src
build_setup := $(build)
setup_name := get_iplayer
setup_ver := $(VERSION).$(PATCH)
setup_suffix := -setup
ifdef NOPERL
	DNOPERL := -DNOPERL
	setup_suffix := $(setup_suffix)-noperl
endif
ifdef NOUTILS
	DNOUTILS := -DNOUTILS
	setup_suffix := $(setup_suffix)-noutils
endif
setup_base := $(setup_name)-$(setup_ver)$(setup_suffix)
setup_file := $(setup_base).exe
setup_src := $(setup_name).iss
gip_zip := get_iplayer-$(gip_tag).zip
build_gip := $(build)
build_gip_zip := $(build_gip)/$(gip_zip)
src_gip := $(src)/get_iplayer
gip_repo := ../get_iplayer
perl_inst := /c/Strawberry
perl := $(perl_inst)/perl/bin/perl
perl_ver := $(shell "$(perl)" -e 'print $$^V')
build_perl := $(build)
build_perl_par := $(build_perl)/perl-$(perl_ver).par
src_perl := $(src)/perl
pp := $(perl_inst)/perl/site/bin/pp
pp_mods := -M Encode::Byte -M JSON -M JSON::XS -M JSON::PP -M Mojolicious -M XML::LibXML -M XML::LibXML::SAX -M XML::LibXML::SAX::Parser -M XML::SAX::PurePerl -M XML::SAX::Expat -M XML::Parser
atomicparsley_zip := AtomicParsley-0.9.6-win32-bin.zip
atomicparsley_zip_url := https://sourceforge.net/projects/get-iplayer/files/utils/$(atomicparsley_zip)
build_atomicparsley := $(build)
build_atomicparsley_zip := $(build_atomicparsley)/$(atomicparsley_zip)
src_atomicparsley := $(src)/atomicparsley
ffmpeg_zip := ffmpeg-4.1-win32-static.zip
ffmpeg_zip_url := https://ffmpeg.zeranoe.com/builds/win32/static/$(ffmpeg_zip)
build_ffmpeg := $(build)
build_ffmpeg_zip := $(build_ffmpeg)/$(ffmpeg_zip)
src_ffmpeg := $(src)/ffmpeg
prog_files := $(shell echo $$PROGRAMFILES)
iscc_inst := $(prog_files)/Inno Setup 5
iscc := $(iscc_inst)/ISCC.exe
gip_inst := $(prog_files)/$(setup_name)
curr_version := $(shell awk '/\#define GiPVersion/ {gsub("\"", "", $$3); print $$3;}' "$(setup_src)")
curr_patch := $(shell awk '/\#define SetupPatch/ {gsub("\"", "", $$3); print $$3;}' "$(setup_src)")
next_version := $(VERSION)
next_patch := $(shell expr $(PATCH) + 1)

dummy:
	@echo Nothing to make

$(build_gip_zip):
ifndef NOGIP
	@mkdir -p "$(build_gip)"
	@git --git-dir="$(gip_repo)"/.git --work-tree="$(gip_repo)" update-index --refresh --unmerged
	@git --git-dir="$(gip_repo)"/.git archive --format=zip $(gip_tag) > "$(build_gip_zip)"
	@echo created $(build_gip_zip)
endif

$(src_gip): $(build_gip_zip)
ifndef NOGIP
	@mkdir -p "$(src_gip)"
	@unzip -j -o -q "$(build_gip_zip)" get_iplayer get_iplayer.cgi LICENSE.txt -d "$(src_gip)"
	@sed -b -E -i.bak -e 's/^(my (\$$version_text|\$$VERSION_TEXT)).*/\1 = "$(setup_ver)-\$$^O";/' \
		"$(src_gip)"/{get_iplayer,get_iplayer.cgi}
	@rm -f "$(src_gip)"/{get_iplayer,get_iplayer.cgi}.bak
	@echo created $(src_gip)
endif

gip: $(src_gip)

$(build_perl_par):
ifndef NOPERL
	@mkdir -p "$(build_perl)";
	@"$(perl)" "$(pp)" $(pp_mods) -B -p -o "$(build_perl_par)" "$(src_gip)"/{get_iplayer,get_iplayer.cgi}
	@echo created $(build_perl_par)
endif
	
$(src_perl): $(src_gip) $(build_perl_par)
ifndef NOPERL
	@mkdir -p "$(src_perl)"
	@unzip -o -q "$(build_perl_par)" -d "$(src_perl)"
	@mkdir -p "$(src_perl)"/licenses
	@cp -f "$(perl_inst)"/licenses/perl/* "$(src_perl)"/licenses
	@cp -fR "$(perl_inst)"/perl/lib/unicore/* "$(src_perl)"/lib/unicore
	@cp -f "$(perl_inst)"/perl/lib/utf8_heavy.pl "$(src_perl)"/lib
	@cp -f "$(perl_inst)"/perl/bin/*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/perl/bin/perl.exe "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/libexpat*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/libiconv*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/libxml2*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/zlib*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/liblzma*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/libcrypto*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/c/bin/libssl*.dll "$(src_perl)"
	@cp -f "$(perl_inst)"/perl/vendor/lib/Mozilla/CA.pm "$(src_perl)"/lib/Mozilla/CA.pm
	@sed -b -E -i.bak -e 's/__FILE__/\$$INC\{"Mozilla\/CA.pm"\}/' "$(src_perl)"/lib/Mozilla/CA.pm
	@rm -f "$(src_perl)"/lib/Mozilla/CA.pm.bak
	@echo created $(src_perl)
endif

perl: $(src_perl)

$(build_atomicparsley_zip):
ifndef NOUTILS
	@mkdir -p "$(build_atomicparsley)"
	@if [ ! -f "$(build_atomicparsley_zip)" ]; then \
		echo Downloading $(atomicparsley_zip); \
		curl -\#fkL -o "$(build_atomicparsley_zip)" "$(atomicparsley_zip_url)" || exit 3; \
	fi;
	@echo created $(build_atomicparsley_zip)
endif

$(src_atomicparsley): $(build_atomicparsley_zip)
ifndef NOUTILS
	@mkdir -p "$(src_atomicparsley)"
	@unzip -j -o -q "$(build_atomicparsley_zip)" AtomicParsley.exe COPYING -d "$(src_atomicparsley)"
	@echo created $(src_atomicparsley)
endif

atomicparsley: $(src_atomicparsley)

$(build_ffmpeg_zip):
ifndef NOUTILS
	@mkdir -p "$(build_ffmpeg)"
	@if [ ! -f "$(build_ffmpeg_zip)" ]; then \
		echo Downloading $(ffmpeg_zip); \
		curl -\#fkL -o "$(build_ffmpeg_zip)" "$(ffmpeg_zip_url)" || exit 3; \
	fi;
	@echo created $(build_ffmpeg_zip)
endif

$(src_ffmpeg): $(build_ffmpeg_zip)
ifndef NOUTILS
	@mkdir -p "$(src_ffmpeg)"
	@unzip -j -o -q "$(build_ffmpeg_zip)" */bin/ffmpeg.exe */LICENSE.txt */README.txt -d "$(src_ffmpeg)"
	@echo created $(src_ffmpeg)
endif

ffmpeg: $(src_ffmpeg)

deps: gip perl atomicparsley ffmpeg

$(build_setup)/$(setup_file): $(setup_src)
ifndef NOSETUP
	@mkdir -p $(build_setup)
	@sed -b -E -i.bak -e 's/(\#define GiPVersion) "[0-9]+\.[0-9]+"/\1 "$(VERSION)"/' \
		-e 's/(\#define SetupPatch) "[0-9]+"/\1 "$(PATCH)"/' $(setup_src)
	@rm -f $(setup_src).bak
	@"$(iscc)" -DGiPVersion="$(VERSION)" -DSetupPatch="$(PATCH)" \
		$(DNOPERL) $(DNOUTILS) -O"$(build_setup)" -F"$(setup_base)" -Q "$(setup_src)"
	@pushd $(build_setup); \
		md5sum $(setup_file) > $(setup_file).md5 || exit 6; \
		sha1sum $(setup_file) > $(setup_file).sha1 || exit 6; \
	popd
	@echo built $(build_setup)/$(setup_file)
endif

setup: $(build_setup)/$(setup_file)

checkout:
ifndef WIP
	@git update-index --refresh --unmerged
	@git checkout master
endif

commit:
ifndef WIP
	@git commit -m "$(setup_ver)" "$(setup_src)"
	@git tag $(setup_ver)
	@git checkout contribute
	@git merge master
	@sed -b -E -i.bak -e 's/(\#define GiPVersion) "[0-9]+\.[0-9]+"/\1 "$(next_version)"/' \
		-e 's/(\#define SetupPatch) "[0-9]+"/\1 "$(next_patch)"/' $(setup_src)
	@git commit -m "bump dev version" "$(setup_src)"
	@git checkout master
	@echo tagged $(setup_ver)
else
	@sed -b -E -i.bak -e 's/(\#define GiPVersion) "[0-9]+\.[0-9]+"/\1 "$(curr_version)"/' \
		-e 's/(\#define SetupPatch) "[0-9]+"/\1 "$(curr_patch)"/' $(setup_src)
	@rm -f $(setup_src).bak
endif

clean:
	@rm -f "$(build_setup)/$(setup_file)"
	@rm -f "$(build_setup)/$(setup_file)".{md5,sha1}
	@echo removed $(build_setup)/$(setup_file)
	@rm -fr "$(src)"
	@echo removed $(src)

distclean: clean
	@rm -fr "$(build)"
	@echo removed $(build)

release: clean checkout deps setup commit
	@echo built release $(setup_ver)

install:
	@"$(build_setup)/$(setup_file)" //VERYSILENT //SUPPRESSMSGBOXES
	@echo installed

uninstall:
	@"$(gip_inst)/unins000.exe" //VERYSILENT //SUPPRESSMSGBOXES
	@echo uninstalled
