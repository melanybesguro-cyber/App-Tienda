class OrderMailer < ApplicationMailer
  def created(order)
    @order = order

    mail(
      to: @order.user.email,
      subject: "Pedido ##{@order.id} recibido correctamente"
    )
  end
end
