# Projet XML — Bulletin de notes académique

**Cours :** Introduction au langage XML
**Type :** Projet individuel

---

## Contexte

Dans le cadre du cours d'Introduction au langage XML, il nous a été demandé de réaliser, en respectant toutes les bonnes pratiques du langage, la modélisation XML d'un document réel au choix : bulletin de notes, facture.

Pour ce projet, j'ai choisi de reproduire un **bulletin de notes académique** dont j'ai trouvé le modèle sur Pinterest. Le modèle original (image de référence) est inclus dans le dossier `assets/` du projet afin d'illustrer la fidélité de la reproduction.

Le document choisi est un relevé de notes officiel délivré par le *Board of Intermediate and Secondary Education, Chattogram (Bangladesh)* pour l'examen *Secondary School Certificate 2022*. Ce choix s'est imposé pour la richesse de sa structure : en-tête institutionnel, barème de notation, données personnelles, tableau de matières avec calcul de GPA, et sections distinctes (obligatoire, optionnel, évaluation continue).

---

## Technologies mises en œuvre

| Technologie | Version | Rôle |
|-------------|---------|------|
| XML | 1.0 | Structuration et stockage des données |
| DTD | — | Définition de la grammaire et validation |
| XSLT | 1.0 | Transformation XML → HTML |
| CSS | 3 | Mise en forme visuelle du rendu |
| HTML | 5 | Document final lisible dans un navigateur |
| Python 3 | 3.x | Transformation XSLT + génération PDF (portable) |

---

## Architecture du projet

```
academic-transcript/
│
├── xml/
│   └── transcript.xml          # Document XML principal (données)
│
├── dtd/
│   └── transcript.dtd          # Définition de la structure (validation)
│
├── xslt/
│   └── transcript.xsl          # Feuille de transformation XSLT 1.0
│
├── css/
│   └── transcript.css          # Feuille de style CSS3
│
├── assets/
│   └── model.jpg               # Modèle original trouvé sur Pinterest
│
├── output/
│   ├── index.html              # Rendu HTML final (ouvrir dans un navigateur)
│   └── transcript.pdf          # PDF généré (via make pdf)
│
├── transform.py                # Script Python : XSLT + PDF (portable)
├── Makefile                    # Automatisation des commandes
└── README.md                   # Ce fichier
```

---

## Description des fichiers

### `xml/transcript.xml`

Fichier source central du projet. Il contient l'intégralité des données du relevé de notes : informations de l'établissement émetteur, barème de notation complet (A → F), données personnelles de l'étudiant(e), liste des matières avec notes et points GPA, et résultats globaux.

Il déclare sa DTD via `<!DOCTYPE academic_transcript SYSTEM "../dtd/transcript.dtd">` et appelle la feuille XSLT via l'instruction de traitement `<?xml-stylesheet ?>`.

### `dtd/transcript.dtd`

Document Type Definition définissant la grammaire formelle du document XML. Il spécifie les éléments autorisés et leur ordre (`ELEMENT`), les attributs et leurs types (`ATTLIST`) avec les mots-clés `#REQUIRED`, `#IMPLIED`, `#FIXED`, et les cardinalités (`+`, `*`, `?`) garantissant la cohérence des données.

### `xslt/transcript.xsl`

Feuille de transformation XSLT 1.0 qui convertit le XML en HTML5. Elle utilise `<xsl:apply-templates>` pour la traversée récursive, `<xsl:for-each>` pour l'itération, `<xsl:value-of>` pour l'extraction des valeurs, et `<xsl:choose>/<xsl:when>` pour la logique conditionnelle.

### `css/transcript.css`

Feuille de style CSS3 reproduisant fidèlement la mise en page du document original : double bordure décorative, flexbox, tableau avec cellules GPA fusionnées, typographie serif académique, et règles `@media print`.

### `output/index.html`

Rendu HTML statique pré-généré par la transformation XSLT. Peut être ouvert directement dans n'importe quel navigateur sans aucun outil supplémentaire.

> **Note :** Les navigateurs modernes bloquent l'exécution XSLT depuis `file://` pour des raisons de sécurité. Le fichier `output/index.html` est donc fourni pré-transformé pour contourner cette contrainte.

### `transform.py`

Script Python portable gérant deux opérations en une seule commande :

- **Sans argument** : applique la transformation XSLT et génère `output/index.html`
- **Avec `--pdf`** : fait la même chose, puis génère `output/transcript.pdf` via `weasyprint`

Ce script est la solution retenue pour la **portabilité maximale** : il fonctionne sur Linux, macOS et Windows sans aucune installation système (xsltproc, wkhtmltopdf, etc.), uniquement avec `pip`.

### `assets/model.jpg`

Image du modèle original utilisé comme référence visuelle pour la reproduction.

---

## Installation et utilisation

### Prérequis Python (toutes plateformes)

```bash
pip install lxml weasyprint
```

- `lxml` — moteur XSLT (transformation XML → HTML)
- `weasyprint` — moteur PDF 100 % Python (pas de binaire système requis)

### Prérequis système optionnels (Linux/macOS)

```bash
# Pour make build via xsltproc (plus rapide que Python sur gros fichiers)
sudo apt-get install xsltproc libxml2-utils make

# wkhtmltopdf N'est PAS requis — weasyprint le remplace
```

---

### Option 1 — Via Makefile (recommandé)

```bash
# Transformer XML → HTML et ouvrir dans le navigateur
make all

# Transformer XML → HTML uniquement
make build

# Générer le PDF (100% Python, aucun outil système)
make pdf

# Valider le XML contre la DTD
make validate

# Ouvrir le rendu HTML dans le navigateur
make open

# Nettoyer les fichiers générés
make clean
```

### Option 2 — Via Python directement

```bash
# HTML uniquement
python3 transform.py

# HTML + PDF
python3 transform.py --pdf
```

Fonctionne identiquement sur **Windows**, **macOS** et **Linux** — aucun outil système requis.

### Option 3 — Ligne de commande xsltproc (Linux/macOS)

```bash
xsltproc xslt/transcript.xsl xml/transcript.xml > output/index.html
```

### Option 4 — Saxon HE (Windows sans WSL)

```bat
java -jar saxon-he.jar -s:xml\transcript.xml -xsl:xslt\transcript.xsl -o:output\index.html
```

### Option 5 — Rendu direct sans outil

Ouvrir directement `output/index.html` dans un navigateur (double-clic ou `Ctrl+O`). Le fichier est pré-généré et ne nécessite aucun outil.

---

## Génération PDF

Le PDF est généré par **`weasyprint`**, une bibliothèque Python pure qui interprète HTML + CSS et produit un PDF fidèle au rendu navigateur — sans dépendance à wkhtmltopdf ou tout autre binaire externe.

```bash
# Installation unique
pip install weasyprint

# Génération
python3 transform.py --pdf
# → output/transcript.pdf

# Ou via Makefile
make pdf
```

> **Pourquoi pas wkhtmltopdf ?**
> wkhtmltopdf est un binaire natif dont l'installation varie selon l'OS et qui n'est plus maintenu activement. `weasyprint` offre la même fonctionnalité en pur Python, installable sur toutes les plateformes avec un simple `pip install`.

---

## Validation DTD

```bash
# Debian/Linux
xmllint --valid --noout xml/transcript.xml

# Via Makefile (xmllint ou python/lxml selon disponibilité)
make validate
```

Un retour silencieux indique que le document est **bien formé et valide**.

---

*Projet individuel — Introduction au langage XML*