require 'rails'
require 'parallel'

INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

# Blueprint 30: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 15 clay. Each geode robot costs 2 ore and 13 obsidian.
REG = Regexp.new 'ore (\d+) clay (\d+) obsidian (\d+) (\d+) geode (\d+) (\d+)'.split(' ').join('\D+')

def parse_blueprints(lines)
  lines.map do |line|
    costs = line.match(REG).to_a[1..].map(&:to_i)
    {
      ore:  { ore: costs[0] },
      clay: { ore: costs[1] },
      obs:  { ore: costs[2], clay: costs[3] },
      geo: { ore: costs[4], obs: costs[5] },
      max: {
        ore: [costs[0], costs[1], costs[2], costs[4]].max,
        clay: costs[3],
        obs: costs[5],
        geo: Float::MAX,
      }
    }
  end
end

def start_robots
  { ore: 1, clay: 0, obs: 0, geo: 0 }
end

def start_collected
  { ore: 0, clay: 0, obs: 0, geo: 0 }
end

def play(blueprint, robots, collected, time, best_max)
  return [best_max, collected[:geo]].max if time <= 0
  return best_max if can_not_collect_more?(collected, time, best_max)

  robot_types_to_build = robots.keys.filter do |robot_type|
    can_build_robot?(blueprint, collected, robot_type) && needs_robot?(blueprint, robots, robot_type)
  end

  # if robot_types_to_build.empty?
  #   collect(blueprint, robots, collected)
  #   return [best_max, play(blueprint, robots, collected, time-1, best_max)].max
  # end

  robot_types_to_build << nil if needs_collect?(blueprint, robots, collected, robot_types_to_build)

  (robot_types_to_build).each do |robot_type|
    robots2, collected2 = [robots.deep_dup, collected.deep_dup]
    build_robot(blueprint, collected2, robot_type) if robot_type
    collect(blueprint, robots2, collected2)
    robots2[robot_type] += 1 if robot_type

    best_max = [best_max, play(blueprint, robots2, collected2, time-1, best_max)].max
  end
  best_max
end

def can_build_robot?(blueprint, collected, robot_type)
  blueprint[robot_type].all? { |type, cost| collected[type] >= cost }
end

def needs_robot?(blueprint, robots, robot_type)
  robots[robot_type] <= blueprint[:max][robot_type]
end

def build_robot(blueprint, collected, robot_type)
  blueprint[robot_type].each { |type, cost| collected[type] -= cost }
end

def needs_collect?(blueprint, robots, collected, robot_types_to_build)
  robots.any? { |type, count| count > 0 && collected[type] < blueprint[:max][type] && !robot_types_to_build.include?(type) }
end

def collect(blue_print, robots, collected)
  robots.each { |robot_type, count| collected[robot_type] += count }
end

def can_not_collect_more?(collected, remaining_time, best_max)
  return if collected[:geo] == 0 || best_max <= 0
  max_to_collect = (collected[:geo]..collected[:geo]+remaining_time).sum
  max_to_collect < best_max
end

def part1(lines)
  Parallel
    .map(parse_blueprints(lines)) do |blueprint|
      play(blueprint, start_robots, start_collected, 24, -1)
    end
    .each_with_index.map { |result, i| result * (i+1) }
    .sum
end

def part2(lines)
  Parallel
    .map(parse_blueprints(lines.take(3))) do |blueprint|
      play(blueprint, start_robots, start_collected, 32, -1)
    end
    .inject(:*)
end

puts part1(INPUT1)
puts part1(INPUT2)

# puts part2(INPUT1)
# puts part2(INPUT2)

# starting blueprint 1
# starting blueprint 2
# starting blueprint 3
# completed blueprint 2 on 1747 with maximum 20 => 20/2 => 10
# completed blueprint 3 on 14586 with maximum 54 => 54/3 => 18
# completed blueprint 1 on 28659 with maximum 38 => 38/1 => 38
# completed ALL on 28659 with result 112
# 10*18*38 = 6840