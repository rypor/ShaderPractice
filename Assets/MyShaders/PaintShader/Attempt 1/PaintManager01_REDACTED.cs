using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

namespace redacted
{
    public class PaintManager01 : MonoBehaviour
    {
        public static PaintManager01 instance;

        [SerializeField] private Shader transparentShader;

        Material transparentMaterial;

        CommandBuffer command;
        private void Awake()
        {
            if (instance != null)
            {
                Debug.LogError("Multiple Paint Managers");
                Destroy(this);
                return;
            }
            instance = this;

            transparentMaterial = new Material(transparentShader);
            transparentMaterial.renderQueue = 3000;
            command = new CommandBuffer();
            command.name = "PaintManager01 Command Buffer";
        }

        public void Init(PaintObject obj)
        {
            Debug.Log("Initializing " + obj.gameObject.name);
            RenderTexture mask = obj.PaintMask;
            Renderer renderer = obj.Rend;

            command.SetRenderTarget(mask);
            command.DrawRenderer(renderer, transparentMaterial, 0);

            Graphics.ExecuteCommandBuffer(command);
            command.Clear();
        }
    }
}