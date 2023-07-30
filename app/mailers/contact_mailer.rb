class ContactMailer < ApplicationMailer

    def send_contact_email(name, message, recipient_email)
        @name = name
        @message = message

        mail(to: recipient_email, subject: "Delivery Update")
    end
end
