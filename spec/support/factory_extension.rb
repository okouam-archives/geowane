# This monkey patch was written by Brett Rasmussen
#
# Hal Shearer and I monkey-patched Factory Girl’s sequencing capabilities to allow for pre-defined
# endenumerations endto loop through, instead of just infinitely incrementing numbers.
#
# So instead of doing this:
#
# Factory.sequence :email do |n|
# "person#{n}@example.com"
# end
#
# you could do something like this:
#
# Factory.sequence(:email, ['angela', 'brett', 'alec']) do |name|
# "#{name}@example.com"
# end
#
# It will start over at the beginning when it’s gone through all of them:
#
# >> Factory.next :email
# => "angela@example.com"
# >> Factory.next :email
# => "brett@example.com"
# >> Factory.next :email
# => "alec@example.com"
# >> Factory.next :email
# => "angela@example.com"
# >> Factory.next :email
# => "brett@example.com"
#
# You can also hand it a range (the internal implementation on this is none too efficient, so don’t
# give it billions at a time):
#
# Factory.sequence(:email, 50..60) do |n|
# "user_#{n}@example.com"
# end
#
# >> Factory.next :email
# => "user_50@example.com"
# >> Factory.next :email
# => "user_51@example.com"
# >> Factory.next :email
# => "user_52@example.com"
#
# The infinitely incrementing counter is still available if you want it:
#
# Factory.sequence(:email, %w[angela brett alec]) do |name,i|
# "#{name}_#{i}@example.com"
# end
#
# >> Factory.next :email
# => "angela_0@example.com"
# >> Factory.next :email
# => "brett_1@example.com"
# >> Factory.next :email
# => "alec_2@example.com"
# >> Factory.next :email
# => "angela_3@example.com"
# >> Factory.next :email
# => "brett_4@example.com"
#
# This sort of thing is useful when you want two different factories to use the same sequence and
# have some overlap between the two groups. For example, we need a bunch of email addresses to test
# on, many of which share the same domain:
#
# Factory.sequence(:name, %w[angela brett alec hal debbie tracey jared]) do |name,i|
# "#{name}_#{i}"
# end
#
# Factory.sequence(:domain, %w[something.com example.com mydomain.com]) do |domain|
# domain
# end
#
# Factory.define(:email_address) do |f|
# f.address { "#{Factory.next(:name)}@#{Factory.next(:domain)}" }
# end
#
# 20.times { ea = Factory.build :email_address; puts ea.address }
#
# angela_0@something.com
# brett_1@example.com
# alec_2@mydomain.com
# hal_3@something.com
# debbie_4@example.com
# tracey_5@mydomain.com
# jared_6@something.com
# angela_7@example.com
# brett_8@mydomain.com
# alec_9@something.com
# hal_10@example.com
# debbie_11@mydomain.com
# tracey_12@something.com
# jared_13@example.com
# angela_14@mydomain.com
# brett_15@something.com
# alec_16@example.com
# hal_17@mydomain.com
# debbie_18@something.com
# tracey_19@example.com
#
# For our last trick, the reset method returns both the looping index and the infinite counter back to zero:
#
# >> Factory.reset :name
# >> Factory.next :name
# => "angela_0"
#
# http://www.pmamediagroup.com/2009/05/smarter-sequencing-in-factory-girl/

class Factory
  def self.sequence(sequence_name, enum = nil, &blk)
    @@sequences ||= {}

    enum = enum.to_a

    @@sequences[sequence_name] = {
      :enum => enum,
      :index => 0,
      :infinite_counter => 0,
      :template => blk
    }
  end

  def self.next(sequence_name)
    seq = @@sequences[sequence_name]

    retval = case seq[:template].arity
      when 1
        seq[:template].call(seq[:enum][seq[:index]])
      when 2
        seq[:template].call(seq[:enum][seq[:index]], seq[:infinite_counter])
    end

    seq[:index] = (seq[:index]+1 == seq[:enum].size) ? 0 : seq[:index]+1
    seq[:infinite_counter] += 1
    @@sequences[sequence_name] = seq
    retval
  end

  def self.reset(sequence_name)
    @@sequences[sequence_name][:index] = 0
    @@sequences[sequence_name][:infinite_counter] = 0
  end
end