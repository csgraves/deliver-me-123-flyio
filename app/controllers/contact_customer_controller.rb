class ContactCustomerController < ApplicationController

    def send_email
        name = current_user.email
        email = params[:email]
        message = params[:message]
        recipient_email = params[:recipient_email]

        ContactMailer.send_contact_email(name, message, recipient_email).deliver_now

        redirect_to root_path, notice: "Email sent."
    end

    def show_form
        check_admin_role
        @delivery = Delivery.find_by(id: params[:delivery_id])
        unless (@delivery.customer_contact.present? && @delivery.customer_contact != '')
          redirect_to root_path, alert: "Unable to contact customer."
        end
        @recipient_email = @delivery.customer_contact

    end

    def check_admin_role
        @delivery = Delivery.find_by(id: params[:delivery_id])
        unless ((current_user.role == "admin" && @delivery.schedule.user.branch.company.id == current_user.branch.company.id) || current_user == @delivery.schedule.user)
          redirect_to root_path, alert: "You do not have permission."
        end
    end
end
