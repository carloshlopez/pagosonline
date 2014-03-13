# encoding: utf-8

module Pagosonline
  class Response
    SIGNATURE_JOIN = "~"

    attr_accessor :client
    attr_accessor :params

    def initialize(client, params = {})
      self.client = client
      self.params = params
    end

    def test?
      params["prueba"] == "1"
    end

    def currency
      params["moneda"]
    end

    def signature
      params["firma"]
    end

    def state_code
      # (params["estado"] || params["estado_pol"]).to_i
      params["estado_pol"].to_i
    end

     def answer_code
      params["codigo_respuesta_pol"].to_i
    end

    def state
      case state_code
        when 1    then :un_oppened
        when 2    then :oppened
        when 4    then :approved
        when 5    then :cancelled  
        when 6    then :declined  
        when 7    then :pending
        when 8    then :reversed
        when 9    then :reversed_fraud
        when 10   then :sent_to_finnancial_institution
        when 11   then :getting_credit_card_info
        when 12   then :pending_pse_confirmation
        when 13   then :ach_debit_active
        when 14   then :pending_efecty
        when 15   then :printed
        when 16   then :ach_debit_registered
        when 101  then :fx_converted
        when 102  then :verified
        when 103  then :submitted      
        when 104  then :error
      end
    end

    def answer_message
      case answer_code
        when 1 then "Transacción aprobada"
        when 2 then "Pago cancelado por el usuario"
        when 3 then "Pago cancelado por el usuario durante validación"
        when 4 then "Transacción rechazada por la entidad"
        when 5 then "Transacción declinada por la entidad"
        when 6 then "Fondos insuficientes"
        when 7 then "Tarjeta invalida"
        when 8 then "Acuda a su entidad"
        when 9 then "Tarjeta vencida"
        when 10 then "Tarjeta restringida"
        when 11 then "Discrecional POL"
        when 12 then "Fecha de expiración o campo seg. Inválidos"
        when 13 then "Repita transacción"
        when 14 then "Transacción inválida"
        when 15 then  "Transacción en proceso de validación"
        when 16 then "Combinación usuario-contraseña inválidos"
        when 17 then "Monto excede máximo permitido por entidad"
        when 18 then "Documento de identificación inválido"
        when 19 then "Transacción abandonada capturando datos TC"
        when 20 then "Transacción abandonada"
        when 21 then "Imposible reversar transacción"
        when 22 then "Tarjeta no autorizada para realizar compras por internet."
        when 23 then "Transacción rechazada"
        when 24 then "Transacción parcial aprobada"
        when 25 then "Rechazada por no confirmación"
        when 26 then "Comprobante generado, esperando pago en banco"
        when 9994 then "Transacción pendiente por confirmar"
        when 9995 then "Certificado digital no encontrado"
        when 9996 then "Entidad no responde"
        when 9997 then "Error de mensajería con la entidad financiera"
        when 9998 then "Error en la entidad financiera"
        when 9999 then "Error no especificado"
      end
    end

    def success?
      self.state == :approved
    end

    def failure?
      [:error, :cancelled, :declined].include? self.state
    end

    def amount
      self.params["valor"].to_f
    end

    def reference
      self.params["ref_venta"]
    end

    def transaccion_id
      self.params["transaccion_id"]
    end

    def valid?
      self.signature.upcase == Digest::MD5.hexdigest([
        self.client.key,
        self.client.account_id,
        self.reference,
        ("%.2f" % self.amount),
        self.currency,
        self.state_code
      ].join(SIGNATURE_JOIN)).upcase
    end
  end
end
