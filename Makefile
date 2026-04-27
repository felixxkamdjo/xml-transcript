# Chemins
XML      = xml/transcript.xml
XSL      = xslt/transcript.xsl
DTD      = dtd/transcript.dtd
OUTPUT   = output/index.html

# Detection de l'OS
UNAME := $(shell uname -s 2>/dev/null || echo Windows)

ifeq ($(UNAME), Linux)
    OPEN_CMD = xdg-open
else ifeq ($(UNAME), Darwin)
    OPEN_CMD = open
else
    # Windows natif
    OPEN_CMD = start
endif

# Cible par defaut
.DEFAULT_GOAL := build

# Cibles
.PHONY: all build validate open clean help

## all : transformation + ouverture navigateur
all: build open

## build : transforme transcript.xml en output/index.html
build: $(OUTPUT)

$(OUTPUT): $(XML) $(XSL)
	@echo "[build] Transformation XSLT en cours..."
	@mkdir -p output
	@if command -v xsltproc > /dev/null 2>&1; then \
		xsltproc $(XSL) $(XML) > $(OUTPUT); \
		echo "[build] OK → $(OUTPUT) (via xsltproc)"; \
	elif command -v python3 > /dev/null 2>&1; then \
		python3 -c "\
from lxml import etree; \
xml = etree.parse('$(XML)'); \
xsl = etree.parse('$(XSL)'); \
html = etree.XSLT(xsl)(xml); \
open('$(OUTPUT)', 'wb').write(etree.tostring(html, pretty_print=True)); \
print('[build] OK → $(OUTPUT) (via python3/lxml)')"; \
	elif command -v java > /dev/null 2>&1 && [ -f saxon-he.jar ]; then \
		java -jar saxon-he.jar -s:$(XML) -xsl:$(XSL) -o:$(OUTPUT); \
		echo "[build] OK → $(OUTPUT) (via Saxon HE)"; \
	else \
		echo "[erreur] Aucun moteur XSLT trouvé."; \
		echo "         Installez xsltproc  : sudo apt-get install xsltproc"; \
		echo "         ou Python 3 + lxml  : pip install lxml"; \
		echo "         ou Saxon HE (Java)  : https://www.saxonica.com"; \
		exit 1; \
	fi

## validate : valide le XML contre la DTD
validate: $(XML) $(DTD)
	@echo "[validate] Validation XML/DTD en cours..."
	@if command -v xmllint > /dev/null 2>&1; then \
		xmllint --valid --noout $(XML) && \
		echo "[validate] OK — document bien formé et valide."; \
	elif command -v python3 > /dev/null 2>&1; then \
		python3 -c "\
from lxml import etree; \
parser = etree.XMLParser(load_dtd=True, validate=True); \
etree.parse('$(XML)', parser); \
print('[validate] OK — document bien formé et valide.')"; \
	else \
		echo "[validate] xmllint introuvable."; \
		echo "           Installez libxml2-utils : sudo apt-get install libxml2-utils"; \
		exit 1; \
	fi

## open : ouvre le rendu HTML dans le navigateur par défaut
open: $(OUTPUT)
	@echo "[open] Ouverture de $(OUTPUT)..."
	@$(OPEN_CMD) $(OUTPUT)

## clean : supprime le HTML genere
clean:
	@echo "[clean] Suppression de $(OUTPUT)..."
	@rm -f $(OUTPUT)
	@echo "[clean] OK."

## help : affiche les cibles disponibles
help:
	@echo ""
	@echo "Projet XML — Bulletin de notes académique"
	@echo "=========================================="
	@echo ""
	@echo "Cibles disponibles :"
	@echo "  make            → transformation XML → HTML (défaut)"
	@echo "  make all        → build + ouverture navigateur"
	@echo "  make build      → transformation XML → HTML"
	@echo "  make validate   → validation XML contre la DTD"
	@echo "  make open       → ouvre output/index.html"
	@echo "  make clean      → supprime le HTML généré"
	@echo "  make help       → affiche cette aide"
	@echo ""
	@echo "Moteurs XSLT supportés (par ordre de priorité) :"
	@echo "  1. xsltproc    (sudo apt-get install xsltproc)"
	@echo "  2. python3/lxml (pip install lxml)"
	@echo "  3. Saxon HE    (java -jar saxon-he.jar)"
	@echo ""
