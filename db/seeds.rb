Team.find_or_create_by!(enrolling: true) do |team|
  team.name = "Default Team"
  team.enrolling = true
end
