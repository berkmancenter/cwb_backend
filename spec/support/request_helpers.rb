module Requests
  def json
    @json ||= JSON.parse(response.body)
  end

  def create_project(name)
    uri = RDF::URI('http://www.example.com/test')
    name = name 
    descript = 'testdescript'
    path = 'testpath' 
    params_array = [uri, name, descript, path]

     CWB::Project.create(params_array) 
  end

end
