defmodule Graph do
  @moduledoc """
  Algoritmos clásicos distribuidos (BFS, DFS)
  """
  # Creacion de Graph
  def new(n) do
    create_graph(Enum.map(1..n, fn _ -> spawn(fn -> loop(-1) end) end), %{}, n)
  end

  defp loop(state) do
    receive do
      {:bfs, graph, new_state} ->
        cond do
          state == -1 || new_state < state ->
            Enum.each(Map.get(graph, self()), fn v -> send(v, {:bfs, graph, new_state + 1}) end)
            loop(new_state)

          true ->
            loop(state)
        end

      {:dfs, graph, new_state, nodos_principales} ->
        # Nodo raiz o principal
        # siempre recibe mensajes
        raiz = Map.get(nodos_principales, self())
        # Vertices no mapeados
        vertice_no_mapeado =
          Map.get(graph, self())
          |> Enum.filter(fn x -> !Map.has_key?(nodos_principales, x) end)

        case vertice_no_mapeado do
          [] ->
            if raiz != self(), do: send(raiz, {:dfs, graph, new_state - 1, nodos_principales})

          [x | _] ->
            nodos_principales = Map.put(nodos_principales, x, self())
            send(x, {:dfs, graph, new_state + 1, nodos_principales})
        end

        if state == -1, do: loop(new_state), else: loop(state)

      # Estos mensajes solo los manda el main.
      {:get_state, caller} ->
        send(caller, {self(), state})
    end
  end

  defp create_graph([], graph, _) do
    graph
  end

  defp create_graph([pid | l], graph, n) do
    g = create_graph(l, Map.put(graph, pid, MapSet.new()), n)
    e = :rand.uniform(div(n * (n - 1), 2))
    create_edges(g, e)
  end

  defp create_edges(graph, 0) do
    graph
  end

  defp create_edges(graph, n) do
    nodes = Map.keys(graph)
    create_edges(add_edge(graph, Enum.random(nodes), Enum.random(nodes)), n - 1)
  end

  defp add_edge(graph, u, v) do
    cond do
      u == nil or v == nil ->
        graph

      u == v ->
        graph

      true ->
        u_neighs = Map.get(graph, u)
        new_u_neighs = MapSet.put(u_neighs, v)
        graph = Map.put(graph, u, new_u_neighs)
        v_neighs = Map.get(graph, v)
        new_v_neighs = MapSet.put(v_neighs, u)
        Map.put(graph, v, new_v_neighs)
    end
  end

  def random_src(graph) do
    Enum.random(Map.keys(graph))
  end

  def bfs(graph, src) do
    send(src, {:bfs, graph, 0})

    # Hace que un hilo duerma durante 5 segundos porque la grafica en si converge a ciertas distancias para cada nodo dependiendo de su origen
    Process.sleep(5000)

    # Resulta que itera sobre un mapa exactamente como lo hace sobre una lista de palabras clave (es decir, usa una tupla):
    Enum.each(Map.keys(graph), fn v -> send(v, {:get_state, self()}) end)
    n = length(Map.keys(graph))

    Enum.map(1..n, fn _ ->
      receive do
        y -> y
      end
    end)
  end

  def bfs(graph) do
    bfs(graph, random_src(graph))
  end

  def dfs(graph, src) do
    send(src, {:dfs, graph, 0, %{src => src}})

    # Hace que un hilo duerma durante 5 segundos porque la grafica en si converge a ciertas distancias para cada nodo dependiendo de su origen
    Process.sleep(5000)

    # Resulta que itera sobre un mapa exactamente como lo hace sobre una lista de palabras clave (es decir, usa una tupla):
    Enum.each(Map.keys(graph), fn v -> send(v, {:get_state, self()}) end)
    n = length(Map.keys(graph))

    Enum.map(1..n, fn _ ->
      receive do
        y -> y
      end
    end)
  end

  def dfs(graph) do
    dfs(graph, random_src(graph))
  end
end
