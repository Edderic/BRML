class Utils
  def initialize(characters)
    @characters = characters
  end

  def combine(accum, num_iteration)
    return accum if num_iteration <= 1

    new_accum = @characters.inject([]) do |accum_1, char|
      accum_1 | accum.map do |item|
        [char, item].flatten
      end
    end

    combine(new_accum, num_iteration - 1)
  end
end
