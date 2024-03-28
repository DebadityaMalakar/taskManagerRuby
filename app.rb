require 'active_record'
require 'sqlite3'

class Task < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'tasks.sqlite3'
)

unless ActiveRecord::Base.connection.table_exists?(:tasks)
  ActiveRecord::Schema.define do
    create_table :tasks do |t|
      t.string :taskName
      t.text :taskDesc
      t.integer :taskDifficulty
      t.timestamps
    end
  end
end

def see_all_tasks
  puts "Displaying all tasks..."
  tasks = Task.all
  tasks.each do |task|
    puts "ID: #{task.id}, Name: #{task.taskName}, Description: #{task.taskDesc}, Difficulty: #{task.taskDifficulty}"
  end
end

def create_new_task
  puts "Enter task name:"
  task_name = gets.chomp

  puts "Enter task description:"
  task_desc = gets.chomp

  puts "Enter task difficulty(1-10):"
  task_difficulty = gets.chomp.to_i

  task = Task.new(
    taskName: task_name,
    taskDesc: task_desc,
    taskDifficulty: task_difficulty
  )

  if task.save
    puts "Task saved successfully!"
  else
    puts "Error saving task: #{task.errors.full_messages.join(', ')}"
  end
end

def modify_existing_task
  see_all_tasks
  puts "Which task would you like to modify? (Enter the task ID number)"
  task_id = gets.chomp.to_i

  task = Task.find_by(id: task_id)

  if task.nil?
    puts "Task with ID #{task_id} not found."
    return
  end

  puts "Enter new task name (leave blank to keep the same):"
  new_task_name = gets.chomp

  puts "Enter new task description (leave blank to keep the same):"
  new_task_desc = gets.chomp

  puts "Enter new task difficulty (1-10) (leave blank to keep the same):"
  new_task_difficulty = gets.chomp.to_i

  # Update the task's attributes if new values are provided
  task.taskName = new_task_name unless new_task_name.empty?
  task.taskDesc = new_task_desc unless new_task_desc.empty?
  task.taskDifficulty = new_task_difficulty unless new_task_difficulty.zero?

  if task.save
    puts "Task updated successfully!"
  else
    puts "Error updating task: #{task.errors.full_messages.join(', ')}"
  end
end



def delete_task
  see_all_tasks
  puts "Enter the ID of the task you want to delete:"
  task_id = gets.chomp.to_i

  task = Task.find_by(id: task_id)

  if task.nil?
    puts "Task with ID #{task_id} not found."
    return
  end

  if task.destroy
    puts "Task deleted successfully!"
  else
    puts "Error deleting task."
  end
end

def display_options
  puts "Ruby Task Manager"
  puts "Poorly written in Ruby by a Teenager"
  puts "Options ::"
  puts "1 See All Tasks"
  puts "2 Create New Task"
  puts "3 Modify an existing task"
  puts "4 Delete a Task"
  puts "5 Help:: Re-display this shit."
  puts "6 Exit"
end

display_options

loop do
  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    see_all_tasks
  when 2
    create_new_task
  when 3
    modify_existing_task
  when 4
    delete_task
  when 5
    display_options
  when 6
    break
  else
    puts "Invalid choice! Please enter a number between 1 and 6."
  end
end
