FROM continuumio/miniconda3:latest
COPY . /root/provision
RUN mkdir -p ~/.local/share ~/.cache ~/.jupyter \
    && conda config --add channels conda-forge \
    && conda config --set channel_priority strict \
    && conda install -y python=3.9 pip pyyaml \
    && python -c 'import yaml, pathlib; y=yaml.full_load(pathlib.Path("/root/provision/conda.yml").read_text()); print(" ".join(d for d in y["dependencies"] if isinstance(d, str)))' \
        | xargs conda install -y \
    && python -c 'import yaml, pathlib; y=yaml.full_load(pathlib.Path("/root/provision/conda.yml").read_text()); print(" ".join(([d["pip"] for d in y["dependencies"] if isinstance(d, dict) and "pip" in d] or [[]])[0]))' \
        | xargs pip install \
    && echo "Python version: `which python`" \
    && conda clean -y --all \
    && rm -rf /root/provision
WORKDIR /root
