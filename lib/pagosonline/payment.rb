module Pagosonline
  class Payment < Hashie::Dash
    GATEWAY = "https://gateway.pagosonline.net/apps/gateway/index.html"
    TEST_GATEWAY= "https://gateway2.pagosonline.net/apps/gateway/index.html"
    SIGNATURE_JOIN = "~"

    attr_accessor :client

    # Configurables
    property :reference, :required => true
    property :description, :required => true
    property :amount, :required => true
    property :currency, :required => true, :default => "COP"
    property :response_url
    property :confirmation_url
    property :extra
    property :buyer_name
    property :buyer_email
    property :language, :default => "es"
    property :iva, :default => 0
    property :dev_iva, :default => 0

    def signature
      Digest::MD5.hexdigest([
        self.client.key,
        self.client.account_id,
        self.reference,
        self.amount,
        self.currency
      ].join(SIGNATURE_JOIN))
    end

    def form(options = {})
      id = params[:id] || "pagosonline"

      form = <<-EOF
        <form
          action="#{self.gateway_url}"
          method="POST"
          id="#{id}"
          class="#{params[:class]}">
      EOF

      self.params.each do |key, value|
        form << "<input type=\"hidden\" name=\"#{key}\" value=\"#{value}\" />" if value
      end

      form << yield if block_given?

      form << "</form>"

      form
    end

    protected
      def gateway_url
        self.client.test? ? TEST_GATEWAY : GATEWAY
      end

      def params
        params = {
          "usuarioId"         => self.client.account_id,
          "refVenta"          => self.reference,
          "firma"             => self.signature,
          "valor"             => self.amount,
          "iva"               => self.iva,
          "baseDevolucionIva" => self.dev_iva,
          "moneda"            => self.currency,
          "descripcion"       => self.description,
          "lng"               => self.language,
          "url_respuesta"     => self.response_url,
          "url_confirmacion"  => self.confirmation_url,
          "nombreComprador"   => self.buyer_name,
          "emailComprador"    => self.buyer_email
        }

        if self.client.test?
          params["prueba"] = 1
        end

        if self.extra
          params["extra1"] = self.extra[0,249]
          params["extra2"] = self.extra[250,499]
        end

        params
      end

  end
end
