class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE students.name = ?"
    row = DB[:conn].execute(sql,name).flatten
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE students.grade = 9"
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE NOT students.grade = 12"
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(count)
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT ?"
    DB[:conn].execute(sql,count).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT 1"
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_x(grade)
    sql = "SELECT * FROM students WHERE students.grade = ?"
    DB[:conn].execute(sql,grade).map {|row| self.new_from_db(row)}
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
