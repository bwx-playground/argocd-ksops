ARG ARGO_CD_VERSION="3.2.0-986e1f85"
# https://github.com/argoproj/argo-cd/blob/master/Dockerfile
ARG KSOPS_VERSION="v4.3.3"

#--------------------------------------------#
#--------Build KSOPS and Kustomize-----------#
#--------------------------------------------#

FROM viaductoss/ksops:$KSOPS_VERSION as ksops-builder

#--------------------------------------------#
#--------Build Custom Argo Image-------------#
#--------------------------------------------#

FROM ghcr.io/argoproj/argo-cd/argocd:$ARGO_CD_VERSION

# # Switch to root for the ability to perform install
# USER root

# Set the kustomize home directory
ENV XDG_CONFIG_HOME=$HOME/.config
ENV KUSTOMIZE_PLUGIN_PATH=$XDG_CONFIG_HOME/kustomize/plugin/

ARG PKG_NAME=ksops

# Override the default kustomize executable with the Go built version
COPY --from=ksops-builder /usr/local/bin/kustomize /usr/local/bin/kustomize

# Add ksops executable to path
COPY --from=ksops-builder /usr/local/bin/ksops /usr/local/bin/ksops

# # Switch back to non-root user
# USER argocd

# # Switch back to non-root user
# USER $ARGOCD_USER_ID