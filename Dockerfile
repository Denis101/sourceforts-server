FROM cm2network/steamcmd
MAINTAINER Denis Craig "admin@deniscraig.com"

# Run Steamcmd and install CSGO
RUN ./home/steam/steamcmd/steamcmd.sh +login anonymous \
        +force_install_dir /home/steam/sourceforts \
        +app_update 232370 validate \
        +app_update 205 validate \
        +app_update 215 validate \
        +quit

RUN { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login anonymous'; \
		echo 'force_install_dir /home/steam/sourceforts/'; \
		echo 'app_update 232370'; \
        echo 'app_update 205'; \
        echo 'app_update 215'; \
		echo 'quit'; \
} > /home/steam/sourceforts/sourceforts_update.txt

# RUN cd /home/steam/csgo-dedicated/csgo && \ 
#     curl https://cm2.network/csgo/cfg.tar.gz -o cfg.tar.gz && \
#     tar -xf cfg.tar.gz && rm cfg.tar.gz

ENV SRCDS_FPSMAX=300 SRCDS_TICKRATE=128 SRCDS_PORT=27015 SRCDS_TV_PORT=27020 SRCDS_MAXPLAYERS=14 SRCDS_TOKEN=0 SRCDS_RCONPW="changeme" SRCDS_PW="changeme"

VOLUME /home/steam/sourceforts

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/sourceforts +app_update 232370 +app_update 205 validate +app_update 215 validate +quit && \
        ./home/steam/sourceforts/srcds_run -game sourceforts -console -autoupdate -steam_dir /home/steam/steamcmd/ -steamcmd_script /home/steam/sourceforts/sourceforts_update.txt -usercon +fps_max $SRCDS_FPSMAX -tickrate $SRCDS_TICKRATE -port $SRCDS_PORT -tv_port $SRCDS_TV_PORT -maxplayers_override $SRCDS_MAXPLAYERS +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $SRCDS_TOKEN +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW +sv_region $SRCDS_REGION

# Expose ports
EXPOSE 27015 27020 27005 51840