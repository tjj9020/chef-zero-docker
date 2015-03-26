FROM centos
MAINTAINER Tim Johnson <tjj9020@gmail.com>

RUN yum update -y
RUN yum install libffi-dev gpg openssh-client openssl-devel zlib1g-devel fiddle openssl  libffi-devel libcurl4-openssl-devel zip git gpg2 unzip tar gcc make automake gcc-c++ patch -y
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo $HOME
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile
ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN echo PATH=$PATH
RUN which rbenv
RUN rbenv init -
RUN rbenv install 2.2.1 && rbenv global 2.2.1

# never install a ruby gem docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

# Install bundler and the "bundle" shim
RUN gem install bundler && rbenv rehash
RUN yum install -y https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.4.0-1.x86_64.rpm
WORKDIR /opt
RUN git clone https://github.com/tjj9020/chef.git
WORKDIR /opt/chef/cookbooks
RUN mkdir -p /etc/chef
RUN ssh-keygen -q -t rsa -N '' -f /etc/chef/validation.pem
RUN chef-client -z -N $HOSTNAME -r 'recipe[my_apache]'

