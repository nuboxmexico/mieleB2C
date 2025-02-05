# Definir la versión de Ruby como una variable ARG
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

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - 
RUN apt-get install -y nodejs

# Instalar Bundler
RUN gem install bundler -v 2.4.22

############################################
# Etapa de dependencias de desarrollo
############################################

# Copiar los archivos Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Configurar Bundler
RUN bundle config set without ''
RUN bundle config set with development test
RUN git config --global url."https://".insteadOf git://

# Instalar dependencias de Ruby
RUN bundle install --jobs=4 --retry=3

############################################
# Etapa de desarrollo
############################################

# Configurar directorio de trabajo
WORKDIR /usr/src

# Copiar el código del proyecto
COPY . .

############################################
# Habilitar SSH y permitir acceso (si es necesario)
############################################

RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd  # Establecer una contraseña para el usuario root
EXPOSE 22  
# Exponer el puerto SSH

# Iniciar SSH y el servidor Rails al mismo tiempo
CMD /usr/sbin/sshd -D & rails server -b '0.0.0.0'
