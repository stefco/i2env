FROM continuumio/miniconda3:latest
COPY . /root/provision
RUN mkdir -p ~/.local/share ~/.cache ~/.jupyter \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
        gcc \
        curl \
        git \
        linux-libc-dev \
        vim \
    && rm -rf /var/lib/apt/lists/* \
    && conda config --add channels conda-forge \
    && conda config --set channel_priority strict \
    && conda install -y python=3.8 pip pyyaml \
    && python -c 'import yaml, pathlib; y=yaml.full_load(pathlib.Path("/root/provision/conda.yml").read_text()); print(" ".join(d for d in y["dependencies"] if isinstance(d, str)))' \
        | xargs conda install -y \
    && pip install ccxt yfinance yahoofinancials telethon git+https://github.com/Binance-docs/Binance_Futures_python.git \
    && echo "Python version: `which python`" \
    && conda clean -y --all \
    && cat /root/provision/.bashrc >>/root/.bashrc \
    && rm -rf /root/provision
WORKDIR /root
    #&& python -c 'import yaml, pathlib; y=yaml.full_load(pathlib.Path("/root/provision/conda.yml").read_text()); print(" ".join(([d["pip"] for d in y["dependencies"] if isinstance(d, dict) and "pip" in d] or [[]])[0]))' \
    #    | xargs pip install \
