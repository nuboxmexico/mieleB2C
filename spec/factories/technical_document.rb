FactoryBot.define do
  factory :technical_document do
    document_file_name {'testsku_fichatecnica.pdf'}
    document_type {'Ficha Técnica'}
    document_updated_at {Date.today}
    product {nil}
  end
end