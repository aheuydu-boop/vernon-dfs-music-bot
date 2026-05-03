FROM node:22
RUN apt-get update && apt-get install -y ffmpeg python3-pip
RUN pip3 install yt-dlp --break-system-packages
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
CMD ["node", "index.js"]
