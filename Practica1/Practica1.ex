defmodule Module1 do
  @moduledoc """
  Calculo de Funciones básicas:
     fibonaccionacci
	   factorial
     random_probability
  """
  # Fibonacci
  # Ejemplo de Ejecucion: Module1.fibonacci(10)
  def fibonacci(0) do
    0
  end

  def fibonacci(1) do
    1
  end

  def fibonacci(n) do
    fibonacci(n-1) + fibonacci(n-2)
  end

 # Factorial
 # Ejemplo de Ejecucion Module1.factorial(5)

  def factorial(n) when n <= 1, do: 1
  def factorial(n) when n > 1, do: n * factorial(n - 1)

  # Random Probability
  # Ejemplo de Ejecucion Module1.random_probability(10)
  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    k = :rand.uniform(n)
    IO.puts("[#{k},...,#{n}]")
    resultado = (n-k+1)/n
    "La Probabilidad es de:, #{resultado}"
  end

  # Un poco de recursividad,combinación de división de enteros y la operación de módulo
  # # Dado un número entero, genera una lista de sus dígitos
 # Ejemplo de Ejecucion Module1.digits(1724)
    def digits(n) when n < 0, do: digits(-n)

    def digits(n) when is_integer(n) do
      calc(n, [])
    end

    defp calc(digit, digits)
      when digit < 10,
      do: [digit | digits]

    defp calc(n, digits) do
      digit = Integer.mod(n, 10)

      n
      |> div(10)
      |> calc([digit | digits])
    end

end

defmodule Module2 do
  def test do
    ok_function = fn() -> :ok end
    ok_function.()
  end

  def solve(a, b, n) do
    solucion = solve_congruence(a,n)
    if (solucion == 1) do
      IO.puts("Si Tiene solución :)")
    else
      :error
    end
  end
#fun aux para determinar si son primos relativos
  def solve_congruence(a, b) do
    if (a<b) do
      solve_congruence(b, a)
    end
    if (b==0) do
      a
    else
      solve_congruence(b, rem(a, b))
    end
  end

end

defmodule Module3 do
#Funcion recursiva para eliminar elementos duplicados
# Ejemplo de ejecucion  Module3.elim_dup([1, 2, 3, 3, 2, 1])
def reverse(list) do
  do_reverse(list, [])
end

defp do_reverse([], reversed) do
  reversed
end

defp do_reverse([h|t], reversed) do
  do_reverse(t, [h|reversed])
end



#FUNCION CRIBA DE ERATHOSTENES
#Recibe un numero mayor a 2 y regresa la lista con los numeros
#primos anteriores al numero ingresado, si es primo el numero
#ingresado entonces regresa el mismo numero con sus antesesores primos.


#Caso 1.- ingrasan un numero menor a dos
def sieve_of_erathostenes(n) when n < 2, do: "Upsss, you did it again. Ingresa un numero natural mayor a dos"

#Caso 2.-ingresan un numero mayor a dos
#Uso de filter para filtrar solo los que evalua a true
def sieve_of_erathostenes(n), do: Enum.filter(2..n, &validarprimo(&1))


  #Funcion auxiliar privada para validar los numeros primos anteriores a la entrada.
  defp validarprimo(n) when n in [2, 3], do: true

  defp validarprimo(x) do

    inicialcot = div(x, 2)
    #Enum.reduce Transforma a un unico valor
    Enum.reduce(2..inicialcot, {true, inicialcot}, fn(fac, {primo, cotsup}) ->

      #Comprueba 3 condiciones en vez de anidarlas en un if
      cond do
        #primer condicion
        !primo -> {false, fac}
        #segunda condicion
        fac > cotsup -> {primo, cotsup}
        #tercera condicion
        true ->
          primo = rem(x, fac) != 0
          cotsup = if primo, do:
                          div(x, fac + 1), else: fac
                          {primo , cotsup}
      end
    end) |> elem(0)
end


  def elim_dup(l) do
    elim_dup(l, MapSet.new)
  end


  defp elim_dup([x | rest], found) do
    if MapSet.member?(found, x) do
      elim_dup(rest, found)
    else
      [x | elim_dup(rest, MapSet.put(found, x))]
    end
  end

  defp elim_dup([], _) do
    []
  end

end

#Tuvimos ciertas dificultades con este ejercio esta fue la forma que pensamos en solucionarlo
#Usamos Genserver

#Despues de probar que compile la clase ingresar {:ok, pid} = Module4.start_link()
#Nos devolvera algo como {:ok, #PID<0.117.0>}
#Probamos que el proceso este vivo con Process.alive?(pid) y nos devuelve
#true

#Agregamos elementos a la lista por que esta vacia al inicio con
#Module4.add(pid,"manzana")
#Module4.add(pid,"sandia")
#Module4.add(pid,"fresa")
#Module4.add(pid,"durazno")

#Para ver los elementos que hemos agregado basta con hacer Module4.view(pid) y obtenemos...
#["durazno", "fresa", "sandia", "manzana"]

#Para remover el elemento final basta con ingresar   Module4.remove(pid,"manzana")
#consultamos el estado de la lista Module4.view(pid) y tenemos...
# ["durazno", "fresa", "sandia"]

#Detenemos el proceso con Module4.stop(pid)

defmodule Module4 do
  use GenServer
  #Client
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  #Operaciones de listas
  def add(pid, item) do
    GenServer.cast(pid, item)
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def remove(pid, item) do
    GenServer.cast(pid, {:remove, item})
  end


  def stop(pid) do
    GenServer.stop(pid, :normal, :infinity)
  end

  #Server
  def terminate(_reason, list) do
    IO.puts("Proceso terminado, lista de elementos final:")
    IO.inspect(list)
    :ok
  end
  def handle_cast({:remove, item}, list) do
    updated_list = Enum.reject(list, fn(i) -> i == item end)
    {:noreply, updated_list}
  end

  def handle_cast(item, list) do
    updated_list = [item|list]
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    IO.puts("Elementos de la lista: ")
    {:reply, list, list}
  end

  def init(list) do
    {:ok, list}
  end
end
