class Battleship::NaiveTable
  include Battleship::TableHelper

  attr_reader :num_total_configurations
  def abs_freq!
    each do |point|
      unsunk_ships.each do |ship|
        ship.start_at(point)
        ship.naive_abs_freq! { @num_total_configurations += 1}
      end
    end
  end
end
