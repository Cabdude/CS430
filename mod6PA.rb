
# factors(n)-must return an Array of all the factors of n,
# in order and without duplicates.
# The result must be [] if n < 1.
# For examples, factors(1) == [1] and factors(12) == [1,2,3,4,6,12]
def factors(n)
  n < 1 ? [] : (1..n).reject {|x| !n.modulo(x).zero?}
end

# primes(n)-must return an Array of all prime numbers less than or equal to n,
# in order and without duplicates. primes must return [] if n < 2.
# For examples, primes(10) == [2,3,5,7].
def primes(n)
  n < 2 ? [] : (2..n).select { |x| (2..x / 2).none? { |i| x.modulo(i).zero? } }
end

# prime_factors(n)-must return an Array of all prime factors of n,
# in order and without duplicates. prime_factors must return [] if n < 2.
# For examples, prime_factors(1) == [] and factors(12) == [2,3].
def prime_factors(n)
  n < 2 ? [] : factors(n).drop(1).select { |x| (2..x / 2).none? { |i| x.modulo(i).zero? } }
end

# perfects(n)-must return an Array of all perfect numbers
# less than or equal to n, in order and without duplicates.
# A perfect number is one whose factors sum to twice the number.
# For example, perfects(10) == [6]
# (because the factors of 6 are 1, 2, 3, and 6, and these sum to 12).
def perfects(n)
  (1..n).select { |x| factors(x).sum == x * 2 }
end

# pythagoreans(n) -must return an Array of Arrays of pythagorean triples
# whose elements are all less than or equal to n, in order without duplicates,
# and such that each triple is ordered. A pythagorean triple is
# three numbers x, y, z such that x² + y² = z².
# For example, pythagoreans(15) == [[3,4,5], [5,12,13], [6,8,10], [9,12,15]].
def pythagoreans(n)
  arr = []
  1.upto(n) { |x| (x + 1..n).map { |y| (y + 1..n).map { |z| x**2 + y**2 == z**2 ? arr.push([x,y,z]) : nil} } }
  arr
end



