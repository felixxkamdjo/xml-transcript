# Chemins
XML      = xml/transcript.xml
XSL      = xslt/transcript.xsl
DTD      = dtd/transcript.dtd
OUTPUT   = output/index.html
PDF      = output/transcript.pdf

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
.PHONY: all build validate open open-pdf pdf clean help

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
		python3 transform.py; \
	elif command -v python > /dev/null 2>&1; then \
		python transform.py; \
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

## pdf : genere output/transcript.pdf et l'ouvre automatiquement
pdf: $(PDF) open-pdf

$(PDF): $(OUTPUT)
	@echo "[pdf] Génération du PDF via Python (weasyprint)..."
	@if command -v python3 > /dev/null 2>&1; then \
		python3 transform.py --pdf; \
	elif command -v python > /dev/null 2>&1; then \
		python transform.py --pdf; \
	else \
		echo "[erreur] Python introuvable."; \
		echo "         Installez Python 3 : https://www.python.org/downloads/"; \
		exit 1; \
	fi

## open-pdf : ouvre le PDF dans le lecteur par défaut
open-pdf: $(PDF)
	@echo "[open] Ouverture de $(PDF)..."
	@$(OPEN_CMD) $(PDF)

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

## clean : supprime les fichiers generes
clean:
	@echo "[clean] Suppression de $(OUTPUT) et $(PDF)..."
	@rm -f $(OUTPUT) $(PDF)
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
	@echo "  make pdf        → génère output/transcript.pdf + ouverture auto"
	@echo "  make open-pdf   → ouvre uniquement le PDF existant"
	@echo "  make validate   → validation XML contre la DTD"
	@echo "  make open       → ouvre output/index.html"
	@echo "  make clean      → supprime le HTML et le PDF générés"
	@echo "  make help       → affiche cette aide"
	@echo ""
	@echo "Moteurs XSLT supportés (par ordre de priorité) :"
	@echo "  1. xsltproc    (sudo apt-get install xsltproc)"
	@echo "  2. python3/lxml (pip install lxml)            ← via transform.py"
	@echo "  3. Saxon HE    (java -jar saxon-he.jar)"
	@echo ""
	@echo "Génération PDF (aucune dépendance système) :"
	@echo "  pip install weasyprint                        ← 100% Python"
	@echo ""