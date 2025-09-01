Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"  # TODO: Restrict this to the react docker-compose service

    resource "/invoices",
      headers: :any,
      methods: [ :get, :post, :options ],
      credentials: false
  end
end
