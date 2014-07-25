module CWB
  class Session < CWB::Resource
    attr_reader :token

    PATTERN = [
      [:resource, RDF::FOAF.sha1, :token]
    ].freeze

    def to_hash
      super.merge(token: @token.to_s)
    end

    def self.create
      token = generate_token
      session_uri = uri(token)

      session_graph = RDF::Graph.new do |graph|
        graph << [session_uri, RDF::FOAF.sha1, token]
      end

      client(:update).insert_data(session_graph, graph: session_uri)
      { token: token }
    end

    def self.destroy_for_token(token)
      session_uri = uri(token)
      client(:update).clear_graph(session_uri)
    end

    def self.uri(token)
      CWB::BASE_URI.join(token.strip)
    end

    def self.generate_token
      Digest::SHA1.hexdigest(rand(36**64).to_s(36)[1..16])
    end
  end
end
