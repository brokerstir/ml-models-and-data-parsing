# table = create_data_table
# hashes = stats_per_team(table)
# exp_table = add_extra_row_columns(table, hashes[0], hashes[1])
# file_prefix = "12-13-23-nba-feed-b"
# write_new_csv_file(exp_table, file_prefix)

def create_data_table
  CSV.read("/Users/robertrisk/Documents/12-13-23-nba-feed-b.csv", {:headers => true, :header_converters => :symbol})
end

def stats_per_team(table)
  count = 2
  stats_per_row = {}
  stats_per_team = {}
  table.each do |row|
    stats_per_row[count] = {
      team: row[:team],
      division: row[:division],
      pts: row[:pts].to_i
    }
    count += 1
    team_key = row[:team]

    stats_per_team[team_key] ||= {
      total_gms: 0,
      total_pts: 0,
      total_or: 0,
      total_dr: 0,
      total_a: 0,
      total_pf: 0,
      total_st: 0,
      total_to: 0,
      total_fg: 0,
      total_fga: 0,
      total_tp: 0,
      total_tpa: 0,
      total_ft: 0,
      total_fta: 0,
      total_oeff: 0,
      total_deff: 0
    }

    attributes_to_update = [
      :total_pts,
      :total_or,
      :total_dr,
      :total_a,
      :total_pf,
      :total_st,
      :total_to,
      :total_fg,
      :total_fga,
      :total_tp,
      :total_tpa,
      :total_ft,
      :total_fta,
      :total_oeff,
      :total_deff
    ]

    stats_per_team[team_key][:total_gms] += 1
    attributes_to_update.each do |attribute|
      stats_per_team[team_key][attribute] += row["#{attribute.to_s.sub("total_", "")}".to_sym].to_i
      binding.pry
    end
  end

  attributes_to_average = [
      :total_pts,
      :total_or,
      :total_dr,
      :total_a,
      :total_pf,
      :total_st,
      :total_to,
      :total_fg,
      :total_fga,
      :total_tp,
      :total_tpa,
      :total_ft,
      :total_fta,
      :total_oeff,
      :total_deff
  ]
  stats_per_team.each do |_, v|
    attributes_to_average.each do |attribute|
      v["avg_#{attribute.to_s.sub("total_", "")}pg".to_sym] = (v[attribute] / v[:total_gms].to_f).round
    end
  end
  
  [stats_per_row, stats_per_team]
end

def add_extra_row_columns(table, stats_per_row, stats_per_team)
  oppossed_prev = false
  count = 2

  table.each do |row|
    opposite_team_index = oppossed_prev ? count - 1 : count + 1
    row[:ou_pts_total] = row[:pts].to_i + stats_per_row[opposite_team_index][:pts]
    row[:team_pts_total] = row[:pts].to_i

    team_stats = stats_per_team[row[:team]]
    row[:team_avg_ptspg] = team_stats[:avg_ptspg]
    row[:team_avg_orpg] = team_stats[:avg_orpg]
    row[:team_avg_drpg] = team_stats[:avg_drpg]
    row[:team_avg_apg] = team_stats[:avg_apg]
    row[:team_avg_pfpg] = team_stats[:avg_pfpg]
    row[:team_avg_stpg] = team_stats[:avg_stpg]
    row[:team_avg_topg] = team_stats[:avg_topg]
    row[:team_avg_fgpg] = team_stats[:avg_fgpg]
    row[:team_avg_fgapg] = team_stats[:avg_fgapg]
    row[:team_avg_tppg] = team_stats[:avg_tppg]
    row[:team_avg_tpapg] = team_stats[:avg_tpapg]
    row[:team_avg_ftpg] = team_stats[:avg_ftpg]
    row[:team_avg_ftapg] = team_stats[:avg_ftapg]
    row[:team_avg_oeffpg] = team_stats[:avg_oeffpg]
    row[:team_avg_deffpg] = team_stats[:avg_deffpg]

    row[:opposite_team] = stats_per_row[opposite_team_index][:team]
    row[:opposite_team_pts_total] = row[:ou_pts_total] - row[:pts].to_i
    
    opposite_team_stats = stats_per_team[row[:opposite_team]]
    row[:opposite_team_avg_ptspg] = opposite_team_stats[:avg_ptspg]
    row[:opposite_team_avg_orpg] = opposite_team_stats[:avg_orpg]
    row[:opposite_team_avg_drpg] = opposite_team_stats[:avg_drpg]
    row[:opposite_team_avg_apg] = opposite_team_stats[:avg_apg]
    row[:opposite_team_avg_pfpg] = opposite_team_stats[:avg_pfpg]
    row[:opposite_team_avg_stpg] = opposite_team_stats[:avg_stpg]
    row[:opposite_team_avg_topg] = opposite_team_stats[:avg_topg]
    row[:opposite_team_avg_fgpg] = opposite_team_stats[:avg_fgpg]
    row[:opposite_team_avg_fgapg] = opposite_team_stats[:avg_fgapg]
    row[:opposite_team_avg_tppg] = opposite_team_stats[:avg_tppg]
    row[:opposite_team_avg_tpapg] = opposite_team_stats[:avg_tpapg]
    row[:opposite_team_avg_ftpg] = opposite_team_stats[:avg_ftpg]
    row[:opposite_team_avg_ftapg] = opposite_team_stats[:avg_ftapg]
    row[:opposite_team_avg_oeffpg] = opposite_team_stats[:avg_oeffpg]
    row[:opposite_team_avg_deffpg] = opposite_team_stats[:avg_deffpg]
    # row[:opposite_team_won] = row[:opposite_team_pts_total] - row[:pts].to_i > 0 ? 1 : 0

    # row[:covered_over] = row[:ou_pts_total] > row[:total].to_i ? 1 : 0
    row[:covered_spread] = (row[:pts].to_i + row[:spread].to_f - row[:opposite_team_pts_total]) > 0 ? 1 : 0
    row[:team_won] = row[:team_pts_total] - (row[:ou_pts_total] - row[:pts].to_i) > 0 ? 1 : 0
  
    oppossed_prev = oppossed_prev ? false : true
    count += 1
  end

  table
end

def write_new_csv_file(table, file_prefix)
  file_path = "/Users/robertrisk/Documents/#{file_prefix}-exp-less.csv"
  CSV.open(file_path, "w") do |f|
    f << table.headers
    table.each do |row|
      next if row[:spread].to_i.abs < 7
      f << row
    end
  end
  puts file_path
end
