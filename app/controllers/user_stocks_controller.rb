class UserStocksController < ApplicationController
  def destroy
    user_stock = UserStock.where(user: current_user, stock: params[:id]).first
    user_stock.destroy

    redirect_to my_stocks_path
  end
end
