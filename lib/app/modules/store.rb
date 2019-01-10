module Store
    def initialize
      @data = ['init message']
    end

    def write_data(data)
      @data = data
    end

    def read_data
      @data
    end
end