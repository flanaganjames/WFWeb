require 'rubygems'
require 'sinatra'

get '/' do
    stream do |out|
        out << "It's gonna be legen -\n"
        sleep 5
        out << " (wait for it) \n"
        sleep 5
        out << "- dary!\n"
    end
end