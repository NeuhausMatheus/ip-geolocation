{{/*
Create a default fully qualified name for resources.
*/}}
{{- define "chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}


{{/*
Get the service account name for the deployment.
*/}}
{{- define "chart.serviceAccountName" -}}
{{- printf "%s-%s" .Release.Name "sa" }}
{{- end -}}
