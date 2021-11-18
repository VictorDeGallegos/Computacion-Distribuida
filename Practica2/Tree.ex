defmodule Tree do

  def new(n) do
    create_tree(Enum.map(1..n, fn _ -> spawn(fn -> loop() end) end), %{}, 0)
  end

  defp loop() do
    receive do
      {:broadcast, tree, i, caller} ->
        izq = Map.get(tree, 2*i+1) # lado_izquierdo
        der = Map.get(tree, 2*i+2) # lado_derecho

        case {izq,der} do
          {nil, nil} -> send(caller, {self(), :ok})
          {izq,der} ->
            send(izq, {:broadcast, tree, 2*i+1, caller})
            if der, do: send(der, {:broadcast, tree, 2*i+2, caller})
        end

        loop() #Aquí va su código.
        {:convergecast, tree, i, caller} ->
          # Si existen 2 nodos, aqui se obtiene el mensaje del otro nodo
          if Map.get(tree, 2*i + 2) do #lado derecho
            receive do
              {:convergecast, _, _, _} -> :ok
            end
          end

          case i do
            0 -> send(caller, {self(), :ok})
            _ ->
              p = div(i-1, 2)
              Map.get(tree, p) |> send({:convergecast, tree, p, caller})
          end

          loop()#Aquí va su código.
    end
  end

  defp create_tree([], tree, _) do
    tree
  end

  #En el arbol tendremos como llave la posicion que ocupa  y como valor el pid de ese nodo
    #Como un heap
  defp create_tree([pid | izq], tree, pos) do
    create_tree(izq, Map.put(tree, pos, pid), (pos+1))
  end

  def broadcast(tree, n) do
    Map.get(tree, 0) |> send({:broadcast, tree, 0, self()}) #El nodo en la llave 0, es la raiz
    Enum.map(1..div(n+1, 2), fn _ -> receive do x -> x end end)
  end

  def convergecast(tree, n) do
    primer_hoja = n - div(n+1, 2)
    Enum.each(primer_hoja..n-1, fn x -> Map.get(tree, x) |> send({:convergecast, tree, x, self()}) end)
    receive do x -> x end
  end

end
