Entities = Sketchup.active_model.entities
$domain = 10
$resolution = 1
$scalar = 1.0
def graph(function)
  d = $domain.to_i * $resolution.to_i
  columns = []
  for i in -d..d
    rows = []
    for j in -d..d
      x = (i / $resolution.to_f).to_s
      y = (j / $resolution.to_f).to_s
      z = function.to_s.gsub("x",x).gsub("y",y) 
      begin
        rows.push Geom::Point3d.new(x.to_f, y.to_f, eval(z) * $scalar.to_f)
      rescue
        rows.push Geom::Point3d.new(x.to_f, y.to_f, 0.0)
      end
    end
    columns.push rows
  end
  i = 1
  while i <= (d * 2) do
    j = 1
    while j <= (d * 2) do
      begin
        Entities.add_face columns[i - 1][j - 1], columns[i][j - 1], columns[i][j], columns[i - 1][j]
      rescue
        Entities.add_face columns[i - 1][j - 1], columns[i][j - 1], columns[i][j]
        Entities.add_face columns[i][j], columns[i - 1][j - 1], columns[i - 1][j]
      end
      j += 1
    end
    i += 1
  end
end