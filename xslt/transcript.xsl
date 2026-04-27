<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
        method="html"
        version="5.0"
        encoding="UTF-8"
        indent="yes"
        doctype-public=""
        doctype-system=""
    />

    <!-- Bilingual rendering template -->
    <xsl:template match="*" mode="bilingual">
        <span class="bilingual">
            <span class="lang-fr">
                <xsl:value-of select="fr"/>
            </span>
            <span class="lang-en">
                <xsl:value-of select="en"/>
            </span>
        </span>
    </xsl:template>

    <!-- Root template -->
    <xsl:template match="/">
        <html lang="fr-en">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title>
                <xsl:value-of select="//student_name"/>
                — Releve de Notes / Academic Transcript
            </title>
            <link rel="stylesheet" href="../css/transcript.css"/>
        </head>
        <body>
            <div class="page-wrapper">
                <xsl:apply-templates select="academic_transcript"/>
            </div>
        </body>
        </html>
    </xsl:template>

    <!-- Main document template -->
    <xsl:template match="academic_transcript">
        <div class="document">
            <div class="border-outer">
            <div class="border-inner">

                <!-- Header section -->
                <header class="doc-header">
                    <div class="header-left">
                        <div class="seal-placeholder">&#9670;</div>
                    </div>
                    <div class="header-center">

                        <!-- Institution name -->
                        <p class="board-name">
                            <xsl:apply-templates select="board_info/board_name" mode="bilingual"/>
                        </p>

                        <!-- Country -->
                        <p class="country">
                            <xsl:apply-templates select="board_info/country" mode="bilingual"/>
                        </p>

                        <!-- Exam title -->
                        <h1 class="exam-title">
                            <xsl:apply-templates select="board_info/exam_title" mode="bilingual"/>
                        </h1>

                        <!-- Serial information -->
                        <div class="serial-line">
                            <span class="label">
                                <span class="bilingual">
                                    <span class="lang-fr">N° de Série</span>
                                    <span class="lang-en">Serial No.</span>
                                </span>
                            </span>
                            <span class="serial-value">
                                <xsl:value-of select="board_info/serial_no"/>
                            </span>
                            <span class="transcript-label">
                                <span class="bilingual">
                                    <span class="lang-fr">RELEVE DE NOTES</span>
                                    <span class="lang-en">ACADEMIC TRANSCRIPT</span>
                                </span>
                            </span>
                        </div>

                    </div>
                    <div class="header-right">
                        <!-- FIXED: grading_scale table now renders the grading scale, not subjects -->
                        <xsl:apply-templates select="grading_scale"/>
                    </div>
                </header>

                <!-- Student information -->
                <section class="student-section">
                    <xsl:apply-templates select="student_info"/>
                </section>

                <!-- Subjects section -->
                <section class="subjects-section">
                    <!-- FIXED: now calls the subjects template with results -->
                    <xsl:apply-templates select="subjects">
                        <xsl:with-param name="results" select="results"/>
                    </xsl:apply-templates>
                </section>

                <!-- Footer -->
                <footer class="doc-footer">
                    <xsl:apply-templates select="examination_info"/>
                    <xsl:apply-templates select="footer"/>
                </footer>

            </div>
            </div>
        </div>
    </xsl:template>

    <!-- ============================================================
         FIXED: Grading scale table — renders the grading scale only
         ============================================================ -->
    <xsl:template match="grading_scale">
        <table class="grading-table">
            <thead>
                <tr>
                    <th>
                        <span class="bilingual">
                            <span class="lang-fr">Note</span>
                            <span class="lang-en">Grade</span>
                        </span>
                    </th>
                    <th>
                        <span class="bilingual">
                            <span class="lang-fr">Intervalle</span>
                            <span class="lang-en">Interval</span>
                        </span>
                    </th>
                    <th>
                        <span class="bilingual">
                            <span class="lang-fr">Points</span>
                            <span class="lang-en">Points</span>
                        </span>
                    </th>
                    <th>
                        <span class="bilingual">
                            <span class="lang-fr">Mention</span>
                            <span class="lang-en">Mention</span>
                        </span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="grade_entry">
                    <tr>
                        <td style="text-align:center; font-weight:bold;">
                            <xsl:value-of select="letter_grade"/>
                        </td>
                        <td style="text-align:center;">
                            <xsl:value-of select="class_interval"/>
                        </td>
                        <td style="text-align:center;">
                            <xsl:value-of select="grade_point"/>
                        </td>
                        <td class="mention-cell">
                            <span class="bilingual">
                                <span class="lang-fr"><xsl:value-of select="mention/fr"/></span>
                                <span class="lang-en"><xsl:value-of select="mention/en"/></span>
                            </span>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <!-- ============================================================
         FIXED: Student information — now complete with all fields
         ============================================================ -->
    <xsl:template match="student_info">
        <div class="student-grid">
            <div class="student-col">

                <!-- Student number -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">N° Etudiant</span>
                            <span class="lang-en">Student No.</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="gbtsl_no"/>
                    </span>
                </div>

                <!-- Student name -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Nom de l'Etudiant</span>
                            <span class="lang-en">Name of Student</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain student-name-val">
                        <xsl:value-of select="student_name"/>
                    </span>
                </div>

                <!-- Father name -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Nom du Pere</span>
                            <span class="lang-en">Father's Name</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="father_name"/>
                    </span>
                </div>

                <!-- Mother name -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Nom de la Mere</span>
                            <span class="lang-en">Mother's Name</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="mother_name"/>
                    </span>
                </div>

                <!-- Institution -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Etablissement</span>
                            <span class="lang-en">Name of Institution</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="institution/fr"/>
                    </span>
                </div>

                <!-- Centre -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Centre</span>
                            <span class="lang-en">Name of Centre</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="centre/fr"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="centre/@code"/>
                        <xsl:text>)</xsl:text>
                    </span>
                </div>

            </div>

            <div class="student-col">

                <!-- Roll No -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">N° de Matricule</span>
                            <span class="lang-en">Roll No.</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="roll_no"/>
                    </span>
                </div>

                <!-- Registration No -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">N° d'Inscription</span>
                            <span class="lang-en">Registration No.</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="registration_no"/>
                        <xsl:text> / </xsl:text>
                        <xsl:value-of select="registration_no/@academic_year"/>
                    </span>
                </div>

                <!-- Type -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Type</span>
                            <span class="lang-en">Type</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:apply-templates select="type" mode="bilingual"/>
                    </span>
                </div>

                <!-- Date of birth -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Date de Naissance</span>
                            <span class="lang-en">Date of Birth</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:value-of select="date_of_birth"/>
                    </span>
                </div>

                <!-- Group / Filiere -->
                <div class="field-row">
                    <span class="field-label">
                        <span class="bilingual">
                            <span class="lang-fr">Filiere</span>
                            <span class="lang-en">Group</span>
                        </span>
                    </span>
                    <span class="field-sep">:</span>
                    <span class="field-value plain">
                        <xsl:apply-templates select="group" mode="bilingual"/>
                    </span>
                </div>

            </div>
        </div>
    </xsl:template>

    <!-- ============================================================
         FIXED: Subjects table — now renders all subject sections
         ============================================================ -->
    <xsl:template match="subjects">
        <xsl:param name="results"/>
        <table class="subjects-table">
            <thead>
                <tr>
                    <th style="width:4%">
                        <span class="bilingual">
                            <span class="lang-fr">N°</span>
                            <span class="lang-en">Sl.</span>
                        </span>
                    </th>
                    <th style="width:46%">
                        <span class="bilingual">
                            <span class="lang-fr">Matiere</span>
                            <span class="lang-en">Name of Subjects</span>
                        </span>
                    </th>
                    <th style="width:10%">
                        <span class="bilingual">
                            <span class="lang-fr">Note</span>
                            <span class="lang-en">Letter Grade</span>
                        </span>
                    </th>
                    <th style="width:10%">
                        <span class="bilingual">
                            <span class="lang-fr">Points</span>
                            <span class="lang-en">Grade Point</span>
                        </span>
                    </th>
                    <th style="width:15%">
                        <span class="bilingual">
                            <span class="lang-fr">Moy. Sans Option</span>
                            <span class="lang-en">GPA (w/o optional)</span>
                        </span>
                    </th>
                    <th style="width:15%">
                        <span class="bilingual">
                            <span class="lang-fr">Moyenne Finale</span>
                            <span class="lang-en">Final GPA</span>
                        </span>
                    </th>
                </tr>
            </thead>
            <tbody>

                <!-- Section label: Mandatory subjects -->
                <tr class="section-label-row">
                    <td colspan="6">
                        <span class="bilingual">
                            <span class="lang-fr">Matieres Obligatoires</span>
                            <span class="lang-en">Mandatory Subjects</span>
                        </span>
                    </td>
                </tr>

                <!-- Mandatory subjects rows -->
                <xsl:for-each select="mandatory_subjects/subject">
                    <xsl:call-template name="subject-row">
                        <xsl:with-param name="results" select="$results"/>
                        <xsl:with-param name="is-last-mandatory"
                            select="position() = last()"/>
                    </xsl:call-template>
                </xsl:for-each>

                <!-- Section label: Optional subjects -->
                <tr class="section-label-row">
                    <td colspan="6">
                        <span class="bilingual">
                            <span class="lang-fr">Matiere Optionnelle</span>
                            <span class="lang-en">Optional Subject</span>
                        </span>
                    </td>
                </tr>

                <!-- Optional subjects rows -->
                <xsl:for-each select="optional_subjects/subject">
                    <xsl:call-template name="subject-row">
                        <xsl:with-param name="results" select="$results"/>
                        <xsl:with-param name="show-gpa-optional"
                            select="position() = last()"/>
                    </xsl:call-template>
                </xsl:for-each>

                <!-- Section label: Continuous assessment -->
                <tr class="section-label-row">
                    <td colspan="6">
                        <span class="bilingual">
                            <span class="lang-fr">Evaluation Continue</span>
                            <span class="lang-en">Subjects of Continuous Assessment</span>
                        </span>
                    </td>
                </tr>

                <!-- Continuous assessment rows -->
                <xsl:for-each select="continuous_assessment/subject">
                    <xsl:call-template name="subject-row">
                        <xsl:with-param name="results" select="$results"/>
                    </xsl:call-template>
                </xsl:for-each>

                <!-- Result summary row -->
                <tr>
                    <td colspan="4" style="text-align:right; padding-right:8px;">
                        <span class="bilingual">
                            <span class="lang-fr" style="font-size:0.78rem;">Mention : <xsl:value-of select="$results/mention/fr"/></span>
                            <span class="lang-en" style="font-size:0.68rem;">Mention: <xsl:value-of select="$results/mention/en"/></span>
                        </span>
                    </td>
                    <td class="gpa-cell">
                        <xsl:value-of select="$results/gpa_without_optional"/>
                    </td>
                    <td class="gpa-cell final-gpa">
                        <xsl:value-of select="$results/final_gpa"/>
                    </td>
                </tr>

            </tbody>
        </table>
    </xsl:template>

    <!-- ============================================================
         Helper: renders a single subject row
         ============================================================ -->
    <xsl:template name="subject-row">
        <xsl:param name="results"/>
        <xsl:param name="is-last-mandatory" select="false()"/>
        <xsl:param name="show-gpa-optional" select="false()"/>
        <tr>
            <td style="text-align:center;">
                <xsl:value-of select="@sl_no"/>
            </td>
            <td class="subject-name-cell">
                <div class="lang-fr"><xsl:value-of select="subject_name/fr"/></div>
                <div class="lang-en"><xsl:value-of select="subject_name/en"/></div>
            </td>
            <td class="gpa-cell">
                <xsl:value-of select="letter_grade"/>
            </td>
            <td class="gpa-cell">
                <xsl:value-of select="grade_point"/>
            </td>
            <!-- GPA without optional: show on last mandatory row, spanning remaining rows -->
            <td class="gpa-cell">
                <xsl:if test="$is-last-mandatory">
                    <xsl:value-of select="$results/gpa_without_optional"/>
                </xsl:if>
                <xsl:if test="$show-gpa-optional">
                    <span class="bilingual" style="font-size:0.65rem;">
                        <span class="lang-fr">GP Option</span>
                        <span class="lang-en">GP Option</span>
                    </span>
                    <br/>
                    <xsl:value-of select="$results/gpa_above_optional"/>
                </xsl:if>
            </td>
            <!-- Final GPA: show only on last mandatory row -->
            <td class="gpa-cell">
                <xsl:if test="$is-last-mandatory">
                    <span class="final-gpa"><xsl:value-of select="$results/final_gpa"/></span>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================
         Examination info (footer left)
         ============================================================ -->
    <xsl:template match="examination_info">
        <div class="footer-left">
            <span class="bilingual">
                <span class="lang-fr">
                    Date de Publication des Resultats :
                    <strong><xsl:value-of select="publication_date/fr"/></strong>
                </span>
                <span class="lang-en">
                    Date of Publication of Result:
                    <strong><xsl:value-of select="publication_date/en"/></strong>
                </span>
            </span>
            <br/>
            <span class="bilingual" style="font-size:0.72rem; margin-top:6px; display:block;">
                <span class="lang-fr">Verifie par / </span>
                <span class="lang-en">Compared By ___________</span>
            </span>
        </div>
    </xsl:template>

    <!-- ============================================================
         Footer right (controller signature)
         ============================================================ -->
    <xsl:template match="footer">
        <div class="footer-right" style="text-align:center;">
            <div class="signature-line"></div>
            <span class="bilingual">
                <span class="lang-fr"><xsl:value-of select="controller/fr"/></span>
                <span class="lang-en"><xsl:value-of select="controller/en"/></span>
            </span>
        </div>
    </xsl:template>

</xsl:stylesheet>
