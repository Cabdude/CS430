# Import project solution
require "./mod07pa.rb"

# Reads in a file consisting of a number of lines. Each line is a space separated pair of floating point numbers.
def readPointsFile path
  File.open(path).readlines.map {|line| line.strip().split.map &:to_f}
end

# Write an SVG header consisting of diagram bounds information.
def genSVGHeader minx, miny, width, height
  "<svg xmlns='http://www.w3.org/2000/svg' width=\"600\" height=\"600\"" +
  " preserveAspectRatio=\"xMinYMid meet\"" +
  " viewbox=\"#{minx} #{miny} #{width + 20} #{height + 20}\">\n" +
  " <g transform=\"translate(10, #{miny + height + 10})\">\n"
end

# Draw a single point as a red circle.
def genSVGPoint point
  "    <circle cx=\"#{point.x}\" cy=\"#{point.y}\" r=\"4\"/>\n"
end

# Draw a set of points.
def genSVGPoints pointSet
  "  <g stroke=\"red\" fill=\"red\" stroke-width=\"0\" transform=\"scale(1 -1)\">\n" +
  ((pointSet.points.map &method(:genSVGPoint)).reduce &:+) +
  "  </g>\n"
end

# Draw a triangle.
def genSVGTriangle triangle
  "    <line x1=\"#{triangle.p1.x}\" y1=\"#{triangle.p1.y}\" x2=\"#{triangle.p2.x}\" y2=\"#{triangle.p2.y}\"/>\n" +
  "    <line x1=\"#{triangle.p1.x}\" y1=\"#{triangle.p1.y}\" x2=\"#{triangle.p3.x}\" y2=\"#{triangle.p3.y}\"/>\n" +
  "    <line x1=\"#{triangle.p2.x}\" y1=\"#{triangle.p2.y}\" x2=\"#{triangle.p3.x}\" y2=\"#{triangle.p3.y}\"/>\n"
end

# Draw a set of triangles using black lines.
def genSVGTriangles triangles, thickness
  "  <g stroke=\"black\" stroke-width=\"#{thickness}\" transform=\"scale(1 -1)\">\n" +
  ((triangles.map &method(:genSVGTriangle)).reduce &:+) +
  "  </g>\n"
end

# Write an SVG footer
def genSVGFooter
  " </g>\n</svg>\n"
end

def main
  if ARGV.length != 2
    puts "Usage: ruby delaunay.rb [input-points-file] [output-svg-file]"
  else

    # read input and convert to internal representation
    pointSet = PointSet.new ((readPointsFile ARGV[0]).map {|p| Point.new *p})

    # generate Delaunay triangulation and output in SVG format
    open(ARGV[1], 'w') do |f|
        f.puts (genSVGHeader *pointSet.bounds) +
               (genSVGTriangles pointSet.delaunay_triangulation, 2) +
               (genSVGPoints pointSet) +
               genSVGFooter
    end
  end
end

main
