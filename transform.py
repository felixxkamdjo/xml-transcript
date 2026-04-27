import os
import sys

try:
    from lxml import etree
except ImportError:
    print("[erreur] lxml n'est pas installé.")
    print("         Installez-le avec : pip install lxml")
    sys.exit(1)

BASE  = os.path.dirname(os.path.abspath(__file__))
XML   = os.path.join(BASE, "xml",    "transcript.xml")
XSL   = os.path.join(BASE, "xslt",   "transcript.xsl")
OUT   = os.path.join(BASE, "output", "index.html")

os.makedirs(os.path.join(BASE, "output"), exist_ok=True)

print("[transform] Chargement de transcript.xml...")
xml_doc  = etree.parse(XML)

print("[transform] Chargement de transcript.xsl...")
xslt_doc = etree.parse(XSL)

print("[transform] Application de la transformation XSLT...")
transform = etree.XSLT(xslt_doc)
result    = transform(xml_doc)

with open(OUT, "wb") as f:
    f.write(etree.tostring(result, pretty_print=True, encoding="UTF-8"))

print(f"[transform] OK → {OUT}")
print("[transform] Ouvrez output/index.html dans votre navigateur.")
