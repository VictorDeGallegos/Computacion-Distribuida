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


defmodule Module3 do

  def rev(l) do
    :ok
  end

  def sieve_of_erathostenes(n) do
    :ok
  end

end

defmodule Module4 do

  def monstructure() do
    :ok
  end
end
