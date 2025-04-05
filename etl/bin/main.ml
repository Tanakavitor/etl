(* Records *)
type order = { id : int; status : string; origin : string }
type order_item = { order_id : int; preco_total : float; total_taxes : float }
type totals = { preco_total : float; total_taxes : float }

(* Funcoes Puras *)

let parse_order line = 
  match line with
  | [id; _client_id; _order_date; status; origin] -> 
      { id = int_of_string id; 
        status; 
        origin }
  | _ -> failwith "Formato Invalido"

let parse_order_item line =
  match line with
  | [order_id; _product_id; quantity; price; tax] ->
      let quantity = int_of_string quantity in
      let price = float_of_string price in
      let tax = float_of_string tax in
      { order_id = int_of_string order_id;
        preco_total = float_of_int quantity *. price;
        total_taxes = tax *. (float_of_int quantity *. price) }
  | _ -> failwith "Formato Invalido"

let calculate_totals_per_order items =
  List.fold_left (fun acc item ->
    let current_total = 
      match List.assoc_opt item.order_id acc with
      | Some total -> total
      | None -> { preco_total = 0.0; total_taxes = 0.0 }
    in
    let updated_total = {
      preco_total = current_total.preco_total +. item.preco_total;
      total_taxes = current_total.total_taxes +. item.total_taxes
    } in
    (item.order_id, updated_total) :: List.remove_assoc item.order_id acc
  ) [] items
  |> List.sort (fun (id1, _) (id2, _) -> compare id1 id2)

let create_rows lista = ["Order ID"; "Total Price"; "Total Taxes"] ::
  List.map (fun (order_id, total) ->
    [string_of_int order_id; 
     Printf.sprintf "%.2f" total.preco_total; 
     Printf.sprintf "%.2f" total.total_taxes]
  ) lista

let filter_orders_by_status orders status =
  match status with
  | "all" -> orders
  | _ -> List.filter (fun order -> order.status = status) orders

let filter_orders_by_origin orders origin =
  match origin with
  | "all" -> orders
  | _ -> List.filter (fun order -> order.origin = origin) orders

let filter_order_items_by_ids order_items order_ids =
  List.filter (fun item -> List.mem item.order_id order_ids) order_items

let remove_header lines =
  match lines with
  | [] -> []
  | _ :: t -> t

(* Funcos Impuras *)

let printar_e_ler msg = 
  Printf.printf "%s" msg; 
  read_line ()

let () =
  let csv_path_orders = "data/order.csv" in
  let lines_orders = Csv.load csv_path_orders in
  let lines_orders = remove_header lines_orders in 
  let orders = List.map parse_order lines_orders in 
  let csv_path_items = "data/order_item.csv" in
  let lines_items = Csv.load csv_path_items in
  let lines_items = remove_header lines_items in  
  let order_items = List.map parse_order_item lines_items in
  let status = printar_e_ler "Digite o status do pedido 'Complete', 'Pending', 'Cancelled' ou 'all': " in
  let origin = printar_e_ler "Digite a origem do pedido 'O', 'P' ou 'all': " in
  let filtered_orders = filter_orders_by_status orders status in
  let filtered_orders = filter_orders_by_origin filtered_orders origin in 
  let order_ids = List.map (fun order -> order.id) filtered_orders in
  let filtered_order_items = filter_order_items_by_ids order_items order_ids in
  let totals_per_order = calculate_totals_per_order filtered_order_items in
  let csv_rows = create_rows totals_per_order in
  let output_csv_path = "output/totals.csv" in
  Csv.save output_csv_path csv_rows