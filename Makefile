MAKEFLAGS  := -j 1

THEME_NAME  = smds

SRC_DIR		= source
INS         = $(SRC_DIR)/beamerthemesmds.ins
PACKAGE_SRC = $(wildcard $(SRC_DIR)/*.dtx)
PACKAGE_STY = $(notdir $(PACKAGE_SRC:%.dtx=%.sty))
DEMO_SRC    = demo/smds-beamer.tex
DEMO_PDF    = demo/smds-beamer.pdf
DOC_SRC     = doc/smdstheme.dtx
DOC_PDF     = doc/smdstheme.pdf
IMAGES_DIR	= images
TDS_TEMPDIR = tds

CTAN_CONTENT = README.md $(INS) $(PACKAGE_SRC) $(DOC_SRC) $(DOC_PDF) $(DEMO_SRC) $(DEMO_PDF) $(IMAGES_DIR)

DESTDIR     ?= 'c:/localtexmf'
INSTALL_DIR  = $(DESTDIR)/tex/latex/$(THEME_NAME)
DOC_DIR      = $(DESTDIR)/doc/latex/$(THEME_NAME)
CACHE_DIR   := $(shell cygpath -t mixed $(shell pwd)/.latex-cache)

LATEX_CMD := latex -output-directory='$(CACHE_DIR)'
COMPILE_TEX := latexmk -pdf -output-directory='$(CACHE_DIR)'
export TEXINPUTS:=$(shell  pwd):$(shell pwd)/source:${TEXINPUTS}

DOCKER_IMAGE = texlive-image
DOCKER_CONTAINER = texlive-build

.PHONY: all sty doc demo clean install uninstall ctan tds clean-cache clean-sty clean-tds ctan-version docker-run docker-build docker-rm

all: sty doc

sty: $(PACKAGE_STY)

doc: $(DOC_PDF)

demo: $(DEMO_PDF)

clean: clean-cache clean-sty clean-tds

install: $(PACKAGE_STY) $(DOC_PDF)
	@mkdir -p $(INSTALL_DIR)
	@cp $(PACKAGE_STY) $(INSTALL_DIR)
	@cp -r $(IMAGES_DIR) $(INSTALL_DIR)
	@mkdir -p $(DOC_DIR)
	@cp $(DOC_PDF) $(DOC_DIR)

uninstall:
	@rm -f "$(addprefix $(INSTALL_DIR)/, $(PACKAGE_STY))"
	@rmdir "$(INSTALL_DIR)"
	@rm -f "$(DOC_DIR)/$(notdir $(DOC_PDF))"
	@rmdir "$(DOC_DIR)"

clean-cache:
	@rm -rf "$(CACHE_DIR)"

clean-sty:
	@rm -f $(PACKAGE_STY)

ctan: $(CTAN_CONTENT) ctan-version
	@tar --transform "s@\(.*\)@smds/\1@" -cf smds-$(shell date "+%Y-%m-%d").tar.gz $(CTAN_CONTENT)

ctan-version:
	@sed -i 's@20[0-9][0-9]/[0-9]*/[0-9]*@$(shell date "+%Y/%m/%d")@' $(PACKAGE_SRC)

tds: sty doc demo
	@echo "Copying LaTeX classes to TDS distribution."
	@mkdir -p "$(TDS_TEMPDIR)/tex/latex/$(THEME_NAME)/"
	@cp -au $(PACKAGE_STY) "$(TDS_TEMPDIR)/tex/latex/$(THEME_NAME)/"
	@cp -au $(IMAGES_DIR) "$(TDS_TEMPDIR)/tex/latex/$(THEME_NAME)/"

	@echo "Copying documentation to TDS distribution."
	@mkdir -p "$(TDS_TEMPDIR)/doc/latex/$(THEME_NAME)/"
	@cp -au $(DOC_PDF) "$(TDS_TEMPDIR)/doc/latex/$(THEME_NAME)/"

	@echo "Copying source files to TDS distribution."
	@mkdir -p "$(TDS_TEMPDIR)/source/latex/$(THEME_NAME)/"
	@cp -au $(SRC_DIR) "$(TDS_TEMPDIR)/source/latex/$(THEME_NAME)/"

	@echo "Creating TDS distribution ZIP archive"
	@cd "$(TDS_TEMPDIR)" && zip -r ../beamer-theme-$(THEME_NAME).tds.zip * && cd -
	@rm -r "$(TDS_TEMPDIR)"

clean-tds:
	@rm -rf "$(TDS_TEMPDIR)" beamer-theme-$(THEME_NAME).tds.zip

$(CACHE_DIR):
	@mkdir -p $(CACHE_DIR)

$(PACKAGE_STY): $(PACKAGE_SRC) $(INS) | clean-cache $(CACHE_DIR)
	cd $(dir $(INS)) && $(LATEX_CMD) $(notdir $(INS))
	@cp $(addprefix $(CACHE_DIR)/,$(PACKAGE_STY)) .

$(DOC_PDF): $(DOC_SRC) $(PACKAGE_STY) | clean-cache $(CACHE_DIR)
	@cd $(dir $(DOC_SRC)) && $(COMPILE_TEX) $(notdir $(DOC_SRC))
	@cp $(CACHE_DIR)/$(notdir $(DOC_PDF)) $(DOC_PDF)

$(DEMO_PDF): $(DEMO_SRC) $(PACKAGE_STY) | clean-cache $(CACHE_DIR)
	@cd $(dir $(DEMO_SRC)) && $(COMPILE_TEX) $(notdir $(DEMO_SRC))
	@cp $(CACHE_DIR)/$(notdir $(DEMO_PDF)) $(DEMO_PDF)

docker-run: docker-build
	docker run --rm=true --name $(DOCKER_CONTAINER) -i -t -v "`cygpath -u $(shell pwd)`":/data $(DOCKER_IMAGE) make

docker-build:
	docker build -t $(DOCKER_IMAGE) docker

docker-rm:
	docker rm $(DOCKER_CONTAINER)
