# ARG RUBY_VERSION=2.6.10

# ############################################
# # builder stage
# ############################################

# FROM ruby:${RUBY_VERSION}

# USER root

# ############################################
# # this section could be different for each project
# RUN apt-get update && apt-get install -y \
#     wkhtmltopdf \
#     qt5-qmake \
#     libqwt-qt5-6 \ 
#     g++ libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
#     && rm -rf /var/lib/apt/lists/*
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
# RUN apt-get update
# RUN apt-get install -y nodejs
# # Update bundler
# #RUN gem update --system 3.2.34
# RUN gem install bundler -v 2.4.22
# ############################################

# ############################################
# # Developement dependencies stage
# ############################################

# COPY Gemfile Gemfile.lock ./
# RUN bundle config set without ''
# RUN bundle config set with development test
# RUN git config --global url."https://".insteadOf git://
# RUN bundle install --jobs=4 --retry=3

# # ############################################
# # ## Development stage
# # ############################################

# WORKDIR /usr/src

# # Copy project code
# COPY . .




#######################---------------------------------------------------------------



# Definir la versión de Ruby como variable ARG
ARG RUBY_VERSION=2.6.10

############################################
# Etapa de construcción
############################################
FROM ruby:${RUBY_VERSION} 

USER root

############################################
# Instalar dependencias del sistema y herramientas necesarias
############################################
RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    qt5-qmake \
    libqwt-qt5-6 \
    g++ libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
    openssh-server \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

############################################
# Instalar Node.js y Bundler
############################################
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Instalar Bundler
RUN gem install bundler -v 2.4.22

############################################
# Etapa de dependencias de desarrollo
############################################

# Configurar directorio de trabajo
WORKDIR /usr/src

# Copiar archivos de dependencias
COPY Gemfile Gemfile.lock ./

# Configurar Bundler
RUN bundle config set without 'development test' && \
    git config --global url."https://".insteadOf git:// && \
    bundle install --jobs=4 --retry=3

############################################
# Etapa de desarrollo
############################################

# Copiar el código del proyecto
COPY . .

############################################
# Habilitar SSH y permitir acceso
############################################
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd  # ⚠️ Cambia 'password' por algo más seguro

# Exponer puertos
EXPOSE 22  
# SSH
EXPOSE 3000  
# Servidor Rails

# Iniciar SSH y el servidor Rails
CMD ["/bin/bash", "-c", "/usr/sbin/sshd -D & exec rails server -b '0.0.0.0'"]
