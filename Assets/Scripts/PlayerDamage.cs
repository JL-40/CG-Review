using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDamage : MonoBehaviour
{
    [SerializeField] Renderer _RimShader;

    [SerializeField] float _Delay = 1.0f;
    float timer = 0.0f;

    [SerializeField] bool _Ouch = false;

    private void Start()
    {
        if (_RimShader == null)
        {
            _RimShader = GetComponent<Renderer>();
        }

        _RimShader.material.SetFloat("_RimPower", 8.0f);

        timer = _Delay;
    }
    public void TakeDamage()
    {

        if (_Ouch)
        {
            _RimShader.material.SetFloat("_RimPower", 0.5f);
        }
        else 
        {
            _RimShader.material.SetFloat("_RimPower", 8.0f);
        }    
    }

    private void Update()
    {
        if (Input.GetKeyUp(KeyCode.Space))
        {
            _Ouch = true;
        }

        TakeDamage();

        if (_Ouch)
        {
            timer -= Time.deltaTime;
            Debug.Log($"Timer: {timer}");

            if (timer <= 0.0f)
            {
                _Ouch = false;
                timer = _Delay;
            }
        }
    }
}
