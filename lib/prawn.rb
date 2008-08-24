# encoding: utf-8

# prawn.rb : A library for PDF generation in Ruby
#
# Copyright April 2008, Gregory Brown.  All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
           
%w[font_ttf].each do |dep|
  $LOAD_PATH.unshift(File.dirname(__FILE__) + "/../vendor/#{dep}")
end

require 'ttf'

module Prawn   
  file = __FILE__
  file = File.readlink(file) if File.symlink?(file)
  dir = File.dirname(file)
                          
  # The base source directory for Prawn as installed on the system
  BASEDIR = File.expand_path(File.join(dir, '..'))
  VERSION = "0.1.99"    

  extend self
  
  def verify_options(accepted,actual)                      
    require "set"
    unless (act=Set[*actual.keys]).subset?(acc=Set[*accepted])
      raise Prawn::Errors::UnknownOption, 
        "\nDetected unknown option(s): #{(act - acc).to_a.inspect}\n" <<
        "Accepted options are: #{accepted.inspect}"
    end    
  end      
  
  module Configurable
    def configuration(*args)
      @config ||= Marshal.load(Marshal.dump(default_configuration))
      if Hash === args[0]
        @config.update(args[0])
      elsif args.length > 1
        @config.values_at(*args)
      elsif args.length == 1
        @config[args[0]] 
      else 
        @config  
      end
    end     
    
    alias_method :C, :configuration
  end
end                                                 

require "prawn/compatibility"
require "prawn/errors"
require "prawn/pdf_object"
require "prawn/graphics"
require "prawn/images"
require "prawn/images/jpg"
require "prawn/images/png"
require "prawn/document"
require "prawn/reference"
require "prawn/font"
