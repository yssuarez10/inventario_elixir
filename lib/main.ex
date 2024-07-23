defmodule InventoryManager do
  defstruct products: []

  def add_product(%InventoryManager{products: products} = inventory_manager, name, price, stock) do
    id = Enum.count(products) + 1
    product = %{id: id, name: name, price: price, stock: stock}
    %{inventory_manager | products: products ++ [product]}
  end

  def list_products(%InventoryManager{products: products}) do
    Enum.each(products, fn product ->
      IO.inspect("#{product.id}. #{product.name}. #{product.price}. #{product.stock}")
    end)
  end

  def increase_stock(%InventoryManager{products: products} = inventory_manager, id, cantity) do
    updated_inventory = Enum.map(products, fn product ->
      if product.id == id do
        new_stock = String.to_integer(product.stock) + cantity
        IO.inspect(%{product | stock: new_stock})
      else
        product
      end
    end)
    %{inventory_manager | products: updated_inventory}
  end

  def sell_stock(%InventoryManager{products: products} = inventory_manager, id, cantity) do
    updated_inventory = Enum.map(products, fn product ->
      if product.id == id do
        new_stock = String.to_integer(product.stock) - cantity
        %{product | stock: new_stock}
      else
        product
      end
    end)
    %{inventory_manager | products: updated_inventory}
  end

  def run do
    inventory_manager = %InventoryManager{}
    loop(inventory_manager)
  end

  defp loop(inventory_manager) do
    IO.puts("""
    Gestor de Inventario
    1. Agregar producto al inventario
    2. Listar productos
    3. Aumentar stock
    4. Disminuir stock
    5. Ver carrito
    6. Pagar
    7. Salir
    """)

    IO.write("Seleccione una opción: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.write("Ingrese la descripcion del producto: ")
        description = IO.gets("") |> String.trim()
        IO.write("Ingrese el precio del producto: ")
        price = IO.gets("") |> String.trim()
        IO.write("Ingrese la cantidad de unidades disponibles: ")
        stock = IO.gets("") |> String.trim()
        inventory_manager = add_product(inventory_manager, description, price, stock)
        loop(inventory_manager)

      2 ->
        list_products(inventory_manager)
        loop(inventory_manager)

      3 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad de unidades a aumentar en el stock: ")
        stock = IO.gets("") |> String.trim() |> String.to_integer()
        inventory_manager = increase_stock(inventory_manager, id, stock)
        loop(inventory_manager)

      4 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad de unidades a disminuir en el stock: ")
        stock = IO.gets("") |> String.trim() |> String.to_integer()
        inventory_manager = sell_stock(inventory_manager, id, stock)
        loop(inventory_manager)

      7 ->
        IO.puts("¡Adiós!")
        :ok

      _ ->
        IO.puts("Opción no válida.")
        loop(inventory_manager)
    end
  end
end

# Ejecutar el gestor de inventario
InventoryManager.run()