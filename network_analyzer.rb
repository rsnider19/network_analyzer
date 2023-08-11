require 'polars-df'

input_file = ARGV[0]

_company_name = "company_name"
_employee_name = "employee_name"
_partner_name = "partner_name"

companies = Polars::DataFrame.new(schema: { _company_name => String })
employees = Polars::DataFrame.new(schema: { _employee_name => String, _company_name => String })
contacts = Polars::DataFrame.new(schema: { _employee_name => String, _partner_name => String })

IO.foreach(input_file) do |line|
  company_match = line.match(/Company (.*)/)
  if company_match
    company = [{ company_name: company_match.captures[0] }]
    companies = companies.vstack(Polars::DataFrame.new(company))
    next
  end

  employee_match = line.match(/Employee (.*) (.*)/)
  if employee_match
    employee = [{ employee_name: employee_match.captures[0], company_name: employee_match.captures[1] }]
    employees = employees.vstack(Polars::DataFrame.new(employee))
    next
  end

  contact_match = line.match(/Contact (.*) (.*) (.*)/)
  if contact_match
    contact = [{ employee_name: contact_match.captures[0], partner_name: contact_match.captures[1] }]
    contacts = contacts.vstack(Polars::DataFrame.new(contact))
  end
end

results = companies
            .join(employees, on: _company_name, how: "left")
            .join(contacts, on: _employee_name, how: "left")
            .groupby(%w[company_name partner_name])
            .count
            .sort("count", reverse: true, nulls_last: true)
            .groupby(_company_name, maintain_order: true)
            .first
            .sort(_company_name)

results.each_row do |r|
  company_name = r[_company_name]
  if (partner = r[_partner_name]) and (count = r["count"])
    puts "#{company_name}: #{partner} (#{count})"
  else
    puts "#{company_name}: No current relationship"
  end
end
