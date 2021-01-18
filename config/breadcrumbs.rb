crumb :root do
  link "Home", root_path
end

crumb :show do
  link "商品詳細", item_path
  parent :root
end

crumb :buy_show do
  link "商品詳細", item_path(params[:item_id])
  parent :root
end

crumb :edit do
  link "商品編集", edit_item_path
  parent :show
end

crumb :buy do
  link "商品購入", item_transactions_path
  parent :buy_show
end