FROM registry.access.redhat.com/ubi8/ruby-27 AS ruby
USER root
RUN gem install asciidoctor asciidoctor-diagram rouge
RUN git config --system --add safe.directory '*'
CMD ["/bin/bash"]