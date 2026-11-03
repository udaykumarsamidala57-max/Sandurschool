from pathlib import Path
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.section import WD_ORIENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_CELL_VERTICAL_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

ROOT = Path(r"C:\Users\srsad\eclipse-workspace\SRSWebsite")
IMGDIR = Path(r"C:\Users\srsad\.codex\generated_images\01a19bd3-a3a9-70b1-b24b-d4ba80ceb54b")
OUT = ROOT / "HRMS_8_Week_Detailed_Development_Plan.docx"

NAVY = "17365D"
TEAL = "138A8A"
PALE = "EAF4F6"
GOLD = "D7A12B"
GRAY = "5B6573"

doc = Document()
sec = doc.sections[0]
sec.orientation = WD_ORIENT.LANDSCAPE
sec.page_width = Inches(11.69)
sec.page_height = Inches(8.27)
sec.top_margin = Inches(0.55)
sec.bottom_margin = Inches(0.55)
sec.left_margin = Inches(0.62)
sec.right_margin = Inches(0.62)

styles = doc.styles
styles["Normal"].font.name = "Aptos"
styles["Normal"]._element.rPr.rFonts.set(qn("w:eastAsia"), "Aptos")
styles["Normal"].font.size = Pt(10)
styles["Normal"].font.color.rgb = RGBColor.from_string("263445")
styles["Normal"].paragraph_format.space_after = Pt(5)
for nm, size, color in [("Title", 25, NAVY), ("Heading 1", 17, NAVY), ("Heading 2", 12, TEAL), ("Heading 3", 10, NAVY)]:
    st = styles[nm]
    st.font.name = "Aptos Display" if nm != "Normal" else "Aptos"
    st._element.rPr.rFonts.set(qn("w:eastAsia"), st.font.name)
    st.font.size = Pt(size)
    st.font.bold = True
    st.font.color.rgb = RGBColor.from_string(color)
    st.paragraph_format.space_before = Pt(8 if nm != "Title" else 0)
    st.paragraph_format.space_after = Pt(5)

def shade(cell, fill):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:fill"), fill)
    tcPr.append(shd)

def set_cell_text(cell, text, bold=False, color=None, size=9):
    cell.text = ""
    p = cell.paragraphs[0]
    p.paragraph_format.space_after = Pt(1)
    p.paragraph_format.space_before = Pt(1)
    r = p.add_run(text)
    r.bold = bold
    r.font.name = "Aptos"
    r.font.size = Pt(size)
    if color:
        r.font.color.rgb = RGBColor.from_string(color)
    cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER

def bullet(text):
    p = doc.add_paragraph(style="List Bullet")
    p.paragraph_format.space_after = Pt(2)
    p.add_run(text)
    return p

def numbered(text):
    p = doc.add_paragraph(style="List Number")
    p.paragraph_format.space_after = Pt(2)
    p.add_run(text)
    return p

def make_table(headers, rows, widths=None, font_size=8.5):
    table = doc.add_table(rows=1, cols=len(headers))
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.style = "Table Grid"
    for i, h in enumerate(headers):
        set_cell_text(table.rows[0].cells[i], h, True, "FFFFFF", font_size)
        shade(table.rows[0].cells[i], NAVY)
    for ridx, row in enumerate(rows):
        cells = table.add_row().cells
        for i, val in enumerate(row):
            set_cell_text(cells[i], str(val), False, None, font_size)
            if ridx % 2 == 1:
                shade(cells[i], "F2F6F8")
    if widths:
        for row in table.rows:
            for i, w in enumerate(widths):
                row.cells[i].width = Inches(w)
    doc.add_paragraph().paragraph_format.space_after = Pt(1)
    return table

def callout(label, text):
    t = doc.add_table(rows=1, cols=1)
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    c = t.cell(0, 0)
    shade(c, PALE)
    c.text = ""
    p = c.paragraphs[0]
    p.paragraph_format.space_after = Pt(3)
    a = p.add_run(label + "  ")
    a.bold = True
    a.font.color.rgb = RGBColor.from_string(TEAL)
    p.add_run(text)
    doc.add_paragraph().paragraph_format.space_after = Pt(1)

# Cover and schedule summary
p = doc.add_paragraph(style="Title")
p.add_run("HR Management Software")
p = doc.add_paragraph()
p.paragraph_format.space_after = Pt(12)
r = p.add_run("Detailed 8 Week Development Plan")
r.bold = True
r.font.size = Pt(16)
r.font.color.rgb = RGBColor.from_string(TEAL)
p = doc.add_paragraph()
p.add_run("Schedule dates: ").bold = True
p.add_run("2 November to 27 December 2026")
p.add_run("    |    Project scope: ").bold = True
p.add_run("Recruitment through payroll, reporting, and employee exit")

doc.add_heading("Purpose and delivery approach", level=1)
doc.add_paragraph("This plan turns the three requested HR software modules into a dated first-release schedule. The eight-week target relies on parallel work across application development, payroll and attendance, reporting, mobile delivery, and testing. The team should confirm business rules and integration access in Week 1 and keep the first Android and biometric release to an agreed set of core workflows.")
callout("Target release", "Initial release review and user acceptance are scheduled for 21–27 December 2026.")

doc.add_heading("Schedule at a glance", level=1)
schedule_rows = [
    ("Week 1", "2–8 Nov 2026", "Requirements, roles, approvals, payroll rules, screen designs, integration and Android scope."),
    ("Week 2", "9–15 Nov 2026", "Core setup, preloaded lists, vacancies, direct application form."),
    ("Week 3", "16–22 Nov 2026", "Candidate and salary tables, dynamic pay components, formula and CTC calculations."),
    ("Week 4", "23–29 Nov 2026", "Management note, proposal, letters, joining documents and training status."),
    ("Week 5", "30 Nov–6 Dec 2026", "Attendance marking, weekly offs, holiday mapping, absence and LOP."),
    ("Week 6", "7–13 Dec 2026", "Final attendance, leave, paid days, payroll calculations, advances and increments."),
    ("Week 7", "14–20 Dec 2026", "HR reports, ESI/PF payment reporting, gratuity summaries, Android and biometric integration."),
    ("Week 8", "21–27 Dec 2026", "End-to-end validation, payroll review, user acceptance, training and initial release."),
]
make_table(["Week", "Dates", "Main work"], schedule_rows, [1.05, 1.55, 7.8], 9)
callout("Parallel work", "Requirements, calculations, reports, Android workflows, and biometric integration are coordinated across overlapping workstreams; the table shows primary milestones.")

# Module 1 detail
doc.add_page_break()
doc.add_heading("Module 1  Recruitment and joining", level=1)
doc.add_paragraph("Module 1 manages direct candidate applications, candidate review, compensation proposals, employment letters, and pre-joining document and training tracking.")
doc.add_heading("1. Direct application form", level=2)
app_rows = [
    ("1", "Candidate name", "Required text field."),
    ("2", "Mobile number", "Required; validate format and support duplicate checks."),
    ("3", "Address", "Candidate address."),
    ("4", "Designation", "Select from a preloaded designation list."),
    ("5", "Date of birth", "Date field."),
    ("6", "Marital status", "Select from configured values."),
    ("7", "Experience", "Capture experience duration and/or summary."),
    ("8", "Previous organization", "Previous employer name/details."),
    ("9", "Qualification", "Education/qualification details."),
    ("10", "Subject", "Optional field."),
    ("11", "Probation details", "Preloaded/configured values; confirm this is what ‘prohibition details’ means."),
    ("12", "Reporting to", "Select from a preloaded employee/manager list."),
    ("13", "Position type", "New position or replacement; capture replacement employee/position details where applicable."),
    ("14", "Appointment type", "Select from configured appointment types."),
    ("15", "Leave policy", "Select from predefined leave policies."),
    ("16", "Salary details", "Capture proposed compensation and component breakdown."),
]
make_table(["#", "Field", "Details"], app_rows, [0.45, 1.9, 8.05], 8)

doc.add_heading("2. Compensation setup", level=2)
for x in [
    "Allow HR to add or remove any number of allowance and deduction components per salary structure.",
    "Each component can be configured as a monthly amount or a constant/fixed value.",
    "Support percentage-based calculations and configurable formulas, including the calculation base for each percentage.",
    "Calculate and display monthly CTC and annual CTC from the configured salary components.",
    "Show the candidate salary details in a comparable table for review and proposal preparation.",
]: bullet(x)

doc.add_heading("3. Candidate review, management note, and proposal", level=2)
for x in [
    "Provide a tabular list of candidates with application and qualification details.",
    "Allow one management note to include more than one employee/candidate selected from submitted applications.",
    "Include background text and pull vacancy details from the vacancy table.",
    "Prepare a proposal with candidate details, salary details in a table, appointment type, leave entitlement, probation period, and confidentiality/non-disclosure text.",
    "Support review and approval before generating employment letters.",
]: bullet(x)

doc.add_heading("4. Letters and joining readiness", level=2)
make_table(["Item", "Expected capability"], [
    ("Offer letter", "Generate from approved candidate, vacancy, and proposal information."),
    ("Appointment letter", "Generate appointment terms, compensation, appointment type, leave policy, probation, and confidentiality clauses."),
    ("Joining letter", "Generate/record joining confirmation and link it to the employee record."),
    ("Document submission", "Track required documents, submission state, and outstanding items."),
    ("Training sessions", "Record planned/completed sessions and status."),
], [1.7, 8.7], 9)

doc.add_heading("5. Module 1 workflow", level=2)
for x in [
    "Candidate submits a direct application against a vacancy.",
    "HR reviews the application, validates details, and selects candidates for consideration.",
    "HR configures compensation, reviews CTC, and prepares a single- or multi-candidate management note and proposal.",
    "Authorized reviewers approve the proposal; HR generates the offer and appointment letters.",
    "HR records joining, document submission, and training status.",
]: numbered(x)

# Module 2 detail
doc.add_page_break()
doc.add_heading("Module 2  Attendance leave payroll and exit", level=1)
doc.add_paragraph("Module 2 converts attendance and leave records into paid days and payroll results, while tracking employee probation and exit procedures.")
doc.add_heading("1. Attendance and calendar", level=2)
for x in [
    "Mark attendance for employees and maintain attendance records by date and payroll period.",
    "Configure weekly offs and map holidays to the applicable calendar or employee group.",
    "Record absences and identify loss of pay (LOP) based on configured attendance and leave rules.",
    "Provide a period-end final attendance step for review and approval before payroll calculation.",
]: bullet(x)

doc.add_heading("2. Leave management", level=2)
make_table(["Leave/pay item", "Required handling"], [
    ("Earned leave", "Maintain entitlement, usage, balance, and applicable accrual rules."),
    ("Casual leave", "Maintain entitlement, usage, balance, and applicable policy rules."),
    ("Leave encashment", "Record eligible encashment and include the approved amount in payroll where applicable."),
    ("Total paid days", "Calculate from approved attendance, weekly offs, holidays, leave, and LOP rules."),
], [2.0, 8.4], 9)

doc.add_heading("3. Payroll and statutory calculations", level=2)
for x in [
    "Calculate salary using approved salary structure, final attendance, total paid days, and LOP.",
    "Calculate employee/employer ESI and PF values using confirmed rules, eligibility, wage bases, and rates.",
    "Calculate gratuity according to the configured eligibility and calculation rules.",
    "Show CTC and payroll component totals for review; retain the monthly and annual salary basis.",
    "Provide a review step before payroll is finalized or marked ready for payment.",
]: bullet(x)

doc.add_heading("4. Employee lifecycle", level=2)
for x in [
    "Track probation status and key dates against the employee record.",
    "Support exit procedures with an employee exit status and completion tracking for required steps.",
]: bullet(x)

callout("Rule configuration", "Payroll rates, eligibility, wage bases, leave accrual, encashment, and paid-day formulas must be confirmed for the applicable jurisdiction and company policies before calculation validation.")

# Module 3 detail
doc.add_page_break()
doc.add_heading("Module 3  Statistics reports and integrations", level=1)
doc.add_paragraph("Module 3 provides management visibility and the integrations needed to use attendance and HR information across web and Android workflows.")
doc.add_heading("1. Statistics and reports", level=2)
make_table(["Report", "Content"], [
    ("HR statistics", "Summary indicators and tabular reports based on configured employee, attendance, leave, and payroll records."),
    ("Month-on-month leave", "Monthly leave usage and balances, with comparisons across months."),
    ("ESI and PF payments", "Period-wise ESI/PF payable and payment tracking/reporting based on finalized payroll."),
    ("Gratuity", "Gratuity calculation details and summary reporting based on employee and configured rules."),
], [2.1, 8.3], 9)

doc.add_heading("2. Staff advances and increments", level=2)
for x in [
    "Record staff advances, amount, date, outstanding balance, and repayment/deduction history.",
    "Record salary increments, effective dates, previous and revised compensation, and approval/history details.",
    "Link approved advance repayments and increments to payroll calculations where applicable.",
]: bullet(x)

doc.add_heading("3. Biometric integration", level=2)
for x in [
    "Connect the selected biometric device or vendor service to import attendance records.",
    "Map imported device identifiers to employee records and dates/times.",
    "Provide an import/reconciliation view for missing, duplicate, or unmatched records before final attendance.",
    "Integration timing depends on vendor access, device model, and availability of a supported API/export method.",
]: bullet(x)

doc.add_heading("4. Android application", level=2)
doc.add_paragraph("Deliver an Android app for the workflows agreed during Week 1. Candidate mobile workflows may include employee attendance, leave requests, approvals, and employee self-service. The exact screens and permissions should be finalized before implementation begins.")

doc.add_heading("5. Reports and integration workflow", level=2)
for x in [
    "Import or update biometric attendance and reconcile it with employee records.",
    "Finalize attendance and payroll for the period.",
    "Generate leave, ESI/PF payment, gratuity, and HR statistics reports.",
    "Use the Android app for the approved employee and manager workflows.",
]: numbered(x)

# Dated implementation plan
doc.add_page_break()
doc.add_heading("Dated 8 week implementation plan", level=1)
doc.add_paragraph("The primary milestone for each week is listed below. Workstreams may overlap to meet the 8-week target.")
detailed_schedule = [
    ("1", "2–8 Nov 2026", "Discovery and setup", "Confirm requirements, roles, approvals, payroll rules, Android workflows, and biometric vendor/device access. Finalize screen designs and project priorities."),
    ("2", "9–15 Nov 2026", "Core and application", "Build sign-in, permissions, organization setup, preloaded lists, vacancy setup, and direct application form."),
    ("3", "16–22 Nov 2026", "Candidate and compensation", "Build candidate and salary tables, dynamic allowances/deductions, fixed or monthly values, formulas, percentage calculations, and monthly/annual CTC."),
    ("4", "23–29 Nov 2026", "Proposal and joining", "Build multi-candidate management notes, vacancy-linked proposals, letter generation, document submission tracking, and training status."),
    ("5", "30 Nov–6 Dec 2026", "Attendance and leave", "Build attendance marking, weekly offs, holiday mapping, absence and LOP handling, leave records, and attendance-period review."),
    ("6", "7–13 Dec 2026", "Payroll and lifecycle", "Build final attendance, earned/casual leave, encashment, paid days, salary calculations, ESI/PF/gratuity/CTC, advances, increments, probation, and exit records."),
    ("7", "14–20 Dec 2026", "Reports and integrations", "Build HR/leave/payments/gratuity reports, agreed Android workflows, and biometric attendance integration; reconcile imported records."),
    ("8", "21–27 Dec 2026", "Review and release", "Run end-to-end review, validate payroll and reports, fix issues, complete user acceptance and training, and prepare the initial release."),
]
make_table(["Week", "Dates", "Focus", "Detailed planned work"], detailed_schedule, [0.48, 1.35, 1.65, 6.92], 8)

doc.add_heading("Release review checklist", level=2)
for x in [
    "Candidate-to-offer-to-joining workflow is reviewable from the application record.",
    "Salary components and monthly/annual CTC reconcile to approved formulas and inputs.",
    "Attendance, holidays, leave, LOP, and paid days reconcile for the selected payroll period.",
    "ESI, PF, gratuity, advances, and increments are validated against approved company and statutory rules.",
    "Reports and Android workflows use the agreed permissions and employee data.",
    "Biometric import and exception reconciliation are demonstrated with the selected device/service, if vendor access is available.",
    "Users complete acceptance review and receive release training.",
]: bullet(x)

doc.add_heading("Schedule assumptions and items to confirm", level=2)
for x in [
    "Requirements, payroll rules, and the Android workflow list are agreed in Week 1.",
    "Biometric vendor access, sample data, and integration documentation are available early in the schedule.",
    "Payroll and statutory calculations are configured for the applicable jurisdiction and confirmed by the responsible business owner.",
    "The term ‘prohibition details’ in the original request is treated as ‘probation details’; confirm this field label.",
    "Detailed exit steps and the Android app's final feature list are confirmed during discovery.",
    "This is an initial release plan; added requirements or delayed external access may change dates.",
]: bullet(x)

# Append three infographic pages
infographics = [
    ("Module 1 infographic", IMGDIR / "exec-0c85f454-8aed-4263-b3b0-002a336c7a8e.png"),
    ("Module 2 infographic", IMGDIR / "exec-4eda45ea-d97b-4b54-a2ad-de40f6979a42.png"),
    ("Module 3 infographic", IMGDIR / "exec-2d40f2f0-b933-4ba0-82b0-a3d95754c9b4.png"),
]
for title, img in infographics:
    doc.add_page_break()
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(5)
    rr = p.add_run(title)
    rr.bold = True
    rr.font.size = Pt(12)
    rr.font.color.rgb = RGBColor.from_string(NAVY)
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(0)
    p.add_run().add_picture(str(img), width=Inches(10.35))

# Page numbers in footer
for section in doc.sections:
    footer = section.footer.paragraphs[0]
    footer.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    run = footer.add_run("HR Management Software | 8-week plan  •  ")
    run.font.size = Pt(8)
    run.font.color.rgb = RGBColor.from_string(GRAY)
    fld = OxmlElement("w:fldSimple")
    fld.set(qn("w:instr"), "PAGE")
    footer._p.append(fld)

doc.core_properties.title = "HR Management Software Detailed 8 Week Development Plan"
doc.core_properties.subject = "Three-module HR software scope and dated implementation schedule"
doc.save(OUT)
print(OUT)
