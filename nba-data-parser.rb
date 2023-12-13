# table = create_table
# hashes = create_teams_hash(table)
# exp_table = add_extra_columns(table, hashes[0], hashes[1])
# 

def create_table
  CSV.read("/Users/robertrisk/Documents/nba-game-stats-00.csv", {:headers => true, :header_converters => :symbol})
end

def create_teams_hash(table)
  count = 2
  stats_hash = {}
  teams_hash = {}
  table.each do |row|
    stats_hash[count] = {}
    stats_hash[count][:team] = row[:team]
    stats_hash[count][:pts] = row[:pts].to_i
    count += 1

    unless teams_hash[row[:team]]
      teams_hash[row[:team]] = {}
      teams_hash[row[:team]][:game_count] = 0
      teams_hash[row[:team]][:total_points] = 0
      teams_hash[row[:team]][:total_rebounds] = 0
      teams_hash[row[:team]][:total_assists] = 0
      teams_hash[row[:team]][:total_steals] = 0
      teams_hash[row[:team]][:total_fg] = 0
      teams_hash[row[:team]][:total_fga] = 0
      teams_hash[row[:team]][:total_tp] = 0
      teams_hash[row[:team]][:total_tpa] = 0
      teams_hash[row[:team]][:total_ft] = 0
      teams_hash[row[:team]][:total_fta] = 0
    end

    teams_hash[row[:team]][:game_count] += 1
    teams_hash[row[:team]][:total_points] += row[:pts].to_i
    teams_hash[row[:team]][:total_rebounds] += row[:totreb].to_i
    teams_hash[row[:team]][:total_assists] += row[:assists].to_i
    teams_hash[row[:team]][:total_steals] += row[:steals].to_i
    teams_hash[row[:team]][:total_fg] += row[:fg].to_i
    teams_hash[row[:team]][:total_fga] += row[:fga].to_i
    teams_hash[row[:team]][:total_tp] += row[:tp].to_i
    teams_hash[row[:team]][:total_tpa] += row[:tpa].to_i
    teams_hash[row[:team]][:total_ft] += row[:ft].to_i
    teams_hash[row[:team]][:total_fta] += row[:fta].to_i
  end

  teams_hash.each do |k,v|
    v[:avg_ppg] = (v[:total_points] / v[:game_count].to_f).round()
    v[:avg_rpg] = (v[:total_rebounds] / v[:game_count].to_f).round()
    v[:avg_apg] = (v[:total_assists] / v[:game_count].to_f).round()
    v[:avg_spg] = (v[:total_steals] / v[:game_count].to_f).round()
    v[:avg_fgp] = (v[:total_fg] / v[:total_fga].to_f).round(2)
    v[:avg_tpp] = (v[:total_tp] / v[:total_tpa].to_f).round(2)
    v[:avg_ftp] = (v[:total_ft] / v[:total_fta].to_f).round(2)
  end

  [stats_hash, teams_hash]
end

def add_extra_columns(table, stats_hash, teams_hash)
  oppossed_prev = false
  count = 2

  table.each do |row|
    unless oppossed_prev
      row[:pts_total] = row[:pts].to_i + stats_hash[count+1][:pts]
      row[:ot] = stats_hash[count+1][:team]
    else
      row[:pts_total] = row[:pts].to_i + stats_hash[count-1][:pts]
      row[:ot] = stats_hash[count-1][:team]
    end

    row[:team_avg_ppg] = teams_hash[row[:team]][:avg_ppg] 
    row[:team_avg_rpg] = teams_hash[row[:team]][:avg_rpg] 
    row[:team_avg_apg] = teams_hash[row[:team]][:avg_apg] 
    row[:team_avg_spg] = teams_hash[row[:team]][:avg_spg] 
    row[:team_avg_fgp] = teams_hash[row[:team]][:avg_fgp] 
    row[:team_avg_tpp] = teams_hash[row[:team]][:avg_tpp] 
    row[:team_avg_ftp] = teams_hash[row[:team]][:avg_ftp] 

    row[:other_team_avg_ppg] = teams_hash[row[:ot]][:avg_ppg] 
    row[:other_team_avg_rpg] = teams_hash[row[:ot]][:avg_rpg] 
    row[:other_team_avg_apg] = teams_hash[row[:ot]][:avg_apg] 
    row[:other_team_avg_spg] = teams_hash[row[:ot]][:avg_spg]
    row[:other_team_avg_fgp] = teams_hash[row[:ot]][:avg_fgp]
    row[:other_team_avg_tpp] = teams_hash[row[:ot]][:avg_tpp]
    row[:other_team_avg_ftp] = teams_hash[row[:ot]][:avg_ftp]

    row[:ot_points] = row[:pts_total] - row[:pts].to_i

    row[:covered_over] = row[:pts_total] > row[:ou_total].to_i ? 1 : 0
    diff = row[:pts].to_i - row[:ot_points]
    row[:covered_spread] = diff > row[:spread].to_f ? 1 : 0

    oppossed_prev = oppossed_prev ? false : true
    count += 1
  end

  table
end


# require "csv"
# file_path = "/Users/robertrisk/Documents/nba-game-stats-expanded-00.csv"
# CSV.open(file_path, "w") do |f|
#   f << table.headers
#   table.each do |row|
#     f << row
#   end
# end

# table = CSV.read("/Users/robertrisk/Documents/nba-game-stats-00.csv", {:headers => true, :header_converters => :symbol})
# table.each do |row|
#   unless teams_hash[row[:team]]
#     teams_hash[row[:team]] = {}
#     teams_hash[row[:team]][:game_count] = 0
#     teams_hash[row[:team]][:total_points] = 0
#     teams_hash[row[:team]][:total_rebounds] = 0
#     teams_hash[row[:team]][:total_assists] = 0
#     teams_hash[row[:team]][:total_steals] = 0
#     teams_hash[row[:team]][:total_fg] = 0
#     teams_hash[row[:team]][:total_fga] = 0
#     teams_hash[row[:team]][:total_tp] = 0
#     teams_hash[row[:team]][:total_pa] = 0
#   end

#   teams_hash[row[:team]][:game_count] += 1
#   teams_hash[row[:team]][:total_points] += row[:pts].to_i
#   teams_hash[row[:team]][:total_rebounds] += row[:totreb].to_i
#   teams_hash[row[:team]][:total_assists] += row[:assists].to_i
#   teams_hash[row[:team]][:total_steals] += row[:steals].to_i
#   teams_hash[row[:team]][:total_fg] += row[:fg].to_i
#   teams_hash[row[:team]][:total_fga] += row[:fga].to_i
#   teams_hash[row[:team]][:total_tp] += row[:tp].to_i
#   teams_hash[row[:team]][:total_tpa] += row[:tpa].to_i
# end

# teams_hash.each do |k,v|
#   v[:avg_ppg] = (v[:total_points] / v[:game_count].to_f).round()
#   v[:avg_rpg] = (v[:total_rebounds] / v[:game_count].to_f).round()
#   v[:avg_apg] = (v[:total_assists] / v[:game_count].to_f).round()
#   v[:avg_spg] = (v[:total_steals] / v[:game_count].to_f).round()
#   v[:avg_fgp] = (v[:total_fg] / v[:total_fga].to_f).round(2)
#   v[:avg_tpp] = (v[:total_tp] / v[:total_tpa].to_f).round(2)
# end

