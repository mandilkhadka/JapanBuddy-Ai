puts "Seeding database..."

# Create a demo user
demo_user = User.find_or_create_by!(email: "demo@japanbuddy.ai") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end
puts "Created demo user: #{demo_user.email}"

# Sample knowledge base documents
documents_data = [
  {
    title: "Residence Card Renewal Guide",
    content: <<~CONTENT
      How to Renew Your Residence Card in Japan

      Your residence card (在留カード / zairyū kādo) is your most important document as a foreign resident in Japan. Here's what you need to know about renewing it:

      WHEN TO RENEW:
      - You should apply for renewal between 3 months before and up to the expiration date
      - If your card expires, you may face penalties or lose your legal status

      WHERE TO GO:
      - Regional Immigration Bureau (入国管理局)
      - Find your local office at: https://www.moj.go.jp/isa/

      REQUIRED DOCUMENTS:
      1. Application form for Extension of Period of Stay (在留期間更新許可申請書)
      2. Current residence card
      3. Valid passport
      4. Photo (4cm x 3cm, taken within 3 months)
      5. Documents proving your status:
         - For work visa: Employment certificate, tax payment certificate
         - For student visa: Certificate of enrollment, attendance record
         - For spouse visa: Marriage certificate, spouse's documents

      FEES:
      - 4,000 yen (revenue stamp / 収入印紙)

      PROCESSING TIME:
      - Usually 2-4 weeks, but can vary

      IMPORTANT TIPS:
      - Always carry your residence card with you
      - Update your address within 14 days of moving
      - If you lose your card, report it immediately
    CONTENT
  },
  {
    title: "Japanese Health Insurance Guide",
    content: <<~CONTENT
      Understanding Health Insurance in Japan

      All residents of Japan, including foreigners, are required to enroll in a health insurance system. Here's what you need to know:

      TWO MAIN TYPES:

      1. Employee Health Insurance (健康保険 / Kenko Hoken)
         - If you work for a company with 5+ employees
         - Premiums are split 50/50 with your employer
         - Automatically enrolled through your company

      2. National Health Insurance (国民健康保険 / Kokumin Kenko Hoken)
         - For self-employed, students, unemployed
         - Register at your local city/ward office
         - Premiums based on your previous year's income

      COVERAGE:
      - You pay 30% of medical costs
      - Insurance covers 70%
      - Children under 6: pay 20%
      - Elderly (70-74): pay 20%
      - Elderly (75+): pay 10%

      HOW TO ENROLL:
      1. Go to your local city/ward office (市区町村役所)
      2. Bring your residence card and My Number card
      3. Fill out the application form
      4. You'll receive your insurance card within 1-2 weeks

      IMPORTANT:
      - Pay your premiums on time to avoid losing coverage
      - If changing jobs, update your insurance within 14 days
      - Keep your insurance card with you when visiting doctors

      HIGH-COST MEDICAL CARE BENEFIT:
      - If your monthly medical expenses exceed a certain limit
      - You can apply for reimbursement
      - Limit depends on your income level
    CONTENT
  },
  {
    title: "Tax Guide for Foreigners in Japan",
    content: <<~CONTENT
      Tax Guide for Foreign Residents in Japan

      If you live and work in Japan, you need to understand the tax system. Here's a comprehensive guide:

      TAX RESIDENCY STATUS:
      - Resident: Living in Japan for 1+ year
      - Non-permanent resident: Resident for less than 5 of the last 10 years
      - Non-resident: Living in Japan for less than 1 year

      MAIN TAXES:

      1. Income Tax (所得税 / Shotokuzei)
         - National tax on your income
         - Progressive rates: 5% to 45%
         - Withheld from salary if employed

      2. Resident Tax (住民税 / Jūminzei)
         - Local tax (prefectural + municipal)
         - Approximately 10% of your taxable income
         - Based on previous year's income
         - Paid from June of the following year

      TAX FILING:
      - If employed with one company: Usually no filing needed
      - Self-employed: Must file by March 15
      - Multiple income sources: Must file by March 15
      - Annual income over 20 million yen: Must file

      TAX DEDUCTIONS:
      - Basic deduction: 480,000 yen
      - Spouse deduction: Up to 380,000 yen
      - Dependent deduction: 380,000 yen per dependent
      - Social insurance premiums: Fully deductible
      - Medical expenses: Deductible if over 100,000 yen

      LEAVING JAPAN:
      - File your final tax return before leaving
      - May need to designate a tax representative
      - You may be eligible for a tax refund

      WHERE TO FILE:
      - Local tax office (税務署 / zeimusho)
      - Online via e-Tax system

      IMPORTANT DATES:
      - Tax year: January 1 - December 31
      - Filing deadline: March 15
      - Year-end adjustment: December (for employees)
    CONTENT
  }
]

documents_data.each do |doc_data|
  document = demo_user.documents.find_or_create_by!(title: doc_data[:title]) do |doc|
    doc.content = doc_data[:content]
    doc.file_type = 'text'
    doc.status = 'completed'
  end
  puts "Created document: #{document.title}"
end

puts "Seeding complete!"
puts ""
puts "Demo credentials:"
puts "  Email: demo@japanbuddy.ai"
puts "  Password: password123"
