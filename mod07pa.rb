# Name:

# TODO: your code goes here


class Point

  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  # Comparison
  def ==(p)
    @x == p.x && @y == p.y
  end

  # Comparison
  def <=>(p)
    p.x == @x ? (@y > p.y ? 1 : -1) : (@x > p.x ? 1 : -1)
  end

  def to_s
    "#{@x}, #{@y}"
  end
end

# Class CCWTriple
class CCWTriple
  attr_accessor :p1
  attr_accessor :p2
  attr_accessor :p3

  def initialize(p1, p2, p3)
    temp = [p1, p2, p3].sort! {|a, b| a <=> b}

    @p1 = p1
    if lefthand_turn?(p1, p2, p3)
      @p2 = p2
      @p3 = p3
    else
      @p2 = p3
      @p3 = p2
    end
  end


  def ==(triple)
    ([@p1, @p2, @p3] - [triple.p1, triple.p2, triple.p3]).empty?
  end

  def to_s
    "[#{@p1}], [#{@p2}], [#{@p3}]"
  end
end

Triangle = CCWTriple


class PointSet

  attr_accessor :points

  def initialize(points = [])
    @points = points
  end

  def size
    @points.length
  end

  def add(p)
    @points.push(p)
    @points.sort! {|a, b| a <=> b}
  end

  def all_triples()
    triples = []

    @points.permutation(3).to_a.each {|a| triples.push(CCWTriple.new(a[0], a[1], a[2]))}

    (0..triples.size - 1).each {|t1|
      (t1 + 1..triples.size - 1).each {|t2|
        !triples[t2].nil? ? (triples[t1] == triples[t2] ? triples[t2] = nil : next) : next
      }
    }
    triples.delete_if(&:nil?)
    triples
  end

  def triples_to_s
    triples = all_triples
    triples.each {|x| p x.to_s}
  end

  def is_delaunay_triangle?(tri)
    (0..size - 1).each {|i|
      return false if in_circle? @points[i], tri.p1, tri.p2, tri.p3
    }
    true
  end

  def delaunay_triangulation
    triples = all_triples
    dl_triangles = []
    (0..triples.size - 1).each {|i|
      dl_triangles.push(triples[i]) if is_delaunay_triangle?(triples[i])
    }
    dl_triangles
  end

  def bounds()
    x_values = []
    y_values = []
    @points.each {|point| x_values.push(point.x); y_values.push(point.y)}
    x_minmax = x_values.minmax
    y_minmax = y_values.minmax

    [x_minmax[0], y_minmax[0], x_minmax[1] - x_minmax[0], y_minmax[1] - y_minmax[0]]

  end
end
# Provided helper functions (DO NOT EDIT PAST THIS LINE!!!)

# Returns true iff point p is in the cicle defined by points p1, p2, and p3.
def in_circle? p, p1, p2, p3
  p1 != p && p2 != p && p3 != p &&
      det4(p1.x, p1.y, p1.x * p1.x + p1.y * p1.y, 1,
           p2.x, p2.y, p2.x * p2.x + p2.y * p2.y, 1,
           p3.x, p3.y, p3.x * p3.x + p3.y * p3.y, 1,
           p.x, p.y, p.x * p.x + p.y * p.y, 1) > 0
end

# Returns true if traveling from p1 to p2, then turning toward p3 is a left-hand
# turn; returns false if its a right-hand turn or p1, p2, and p3 are collinear.
def lefthand_turn?(p1, p2, p3)
  (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y) > 0
end

# Utility function: calculate determinant of 2x2 matrix
# | a b |
# | c d |
def det2 a, b,
         c, d
  a * d - b * c
end

# Utility function: calculate determinant of 3x3 matrix
# | a b c |
# | d e f |
# | g h i |
def det3 a, b, c,
         d, e, f,
         g, h, i
  a * (det2 e, f, h, i) -
      b * (det2 d, f, g, i) +
      c * (det2 d, e, g, h)
end

# Utility function: calculate determinant of 4x4 matrix
# | a b c d |
# | e f g h |
# | i j k l |
# | m n o p |
def det4 a, b, c, d,
         e, f, g, h,
         i, j, k, l,
         m, n, o, p
  a * (det3 f, g, h, j, k, l, n, o, p) -
      b * (det3 e, g, h, i, k, l, m, o, p) +
      c * (det3 e, f, h, i, j, l, m, n, p) -
      d * (det3 e, f, g, i, j, k, m, n, o)
end

